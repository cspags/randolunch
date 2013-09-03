class SearchesController < ApplicationController
	include Yelp::V2::Search::Request

	DEFAULT_REQUEST_SIZE = 20
	DEFAULT_REQUEST_DISTANCE = 1609.34

	def new
		@search = Search.new
	end

	def create
		@search = Search.new(params[:search])

		if @search.valid?
			client = Yelp::Client.new

			# 1. Get total restaurants for the provided criteria
			search_request = get_location_search_request(
				@search.search_term.blank? ? "" : @search.search_term, 
				@search.location,
				get_distance_in_meters(@search.distance, @search.distance_unit),
				limit: 1
			)

			total_response = client.search(search_request)

			# 2. Get random offset based on total number of restaurants found
			# For example if there are 400 restaurants random offset might be 268
			# This way we won't return the same 20 restaurants every time
			offset = 0
			if total_response && total_response["total"] && total_response["total"] > 0
				max_offset = total_response["total"] - DEFAULT_REQUEST_SIZE
				if max_offset < 0
					max_offset = 0
				elsif max_offset > 1000
					# Yelp API max offset allowed is 1000
					max_offset = 1000
				end

				offset = Random.rand(max_offset + 1)

			else
				@search.errors.add(:location, "^Oh no! We couldn't find a restaurant for you.  Try broadening your search criteria.")
				logger.debug "******************************************************"
				logger.debug "Error occurred - 37"
				logger.debug "#{total_response}"
				logger.debug "******************************************************"
				render "new"
				return
			end

			# 3. Now perform the search to get the restaurant list
			search_request = get_location_search_request(
				@search.search_term.blank? ? "" : @search.search_term, 
				@search.location,
				get_distance_in_meters(@search.distance, @search.distance_unit),
				offset: offset
			)

			@temp_response = client.search(search_request)

			if @temp_response && @temp_response["total"] && @temp_response["total"] > 0
				@restaurant_list = @temp_response["businesses"].map { |item| item["name"] }.shuffle

				# Select a random item
				rest_sample = @restaurant_list.sample
				selected_item = @temp_response["businesses"]
					.select { |item| item["name"] == rest_sample }.first

				unless selected_item.nil?
					@winner = {
						name: selected_item["name"],
						rating_img_url: selected_item["rating_img_url"],
						rating_text: selected_item["rating"],
						url: selected_item["url"],
						phone: selected_item["display_phone"],
						review_count: selected_item["review_count"],
						address: selected_item["location"]["display_address"],
						address_for_geocode: get_address_for_geocode(selected_item)
					}.to_json
				end

				if @winner.nil?
					logger.debug "******************************************************"
					logger.debug "winner is nil"
					logger.debug "sample: #{rest_sample}"
					logger.debug "******************************************************"
				end

				@restaurant_list = @restaurant_list.to_json
			else
				logger.debug "******************************************************"
				logger.debug "Error occurred - 85"
				logger.debug "#{@temp_response}"
				logger.debug "******************************************************"
				render "new"
			end
		else
			# Validation error occured
			render "new"
		end
	end

	private

	def get_location_search_request(term, address, radius_filter, options = {})
		default_options = { limit: DEFAULT_REQUEST_SIZE, offset: 0 }
		options = default_options.merge(options)

		Location.new(
			term: term,
			address: address,
			category_filter: "restaurants",
			limit: options[:limit],
			offset: options[:offset],
			radius_filter: radius_filter,
			consumer_key: ENV["RANDOLUNCH_YELP_CONSUMER_KEY"],
			consumer_secret: ENV["RANDOLUNCH_YELP_CONSUMER_SECRET"],
			token: ENV["RANDOLUNCH_YELP_TOKEN"],
			token_secret: ENV["RANDOLUNCH_YELP_TOKEN_SECRET"])
	end

	def get_address_for_geocode(item)
		address = item["location"]["address"].join(" ")
		address += " " + item["location"]["city"]
	end

	def get_distance_in_meters(distance, unit)
		distance_in_meters = DEFAULT_REQUEST_DISTANCE
		if unit == "miles"
			distance_in_meters = distance.to_f * 1609.34
		elsif unit == "kilometers"
			distance_in_meters = distance.to_f * 1000.0
		end

		# Yelp max distance = 40,000 meters - should never happen but just in case
		if distance_in_meters > 40000.0
			distance_in_meters = 40000.0
		end

		# Also should never happen
		if distance_in_meters <= 0.0
			distance_in_meters = DEFAULT_REQUEST_DISTANCE
		end

		return distance_in_meters	
	end
end
