class SearchesController < ApplicationController
	include Yelp::V2::Search::Request

	def new
		@search = Search.new
	end

	def create
		@search = Search.new(params[:search])

		if(@search.valid?)
			client = Yelp::Client.new

			search_request = Location.new(
				term: @search.search_term.blank? ? "" : @search.search_term, 
				address: @search.location,
				category_filter: "restaurants",
				consumer_key: ENV["RANDOLUNCH_YELP_CONSUMER_KEY"],
				consumer_secret: ENV["RANDOLUNCH_YELP_CONSUMER_SECRET"],
				token: ENV["RANDOLUNCH_YELP_TOKEN"],
				token_secret: ENV["RANDOLUNCH_YELP_TOKEN_SECRET"])
			
			@temp_response = client.search(search_request)

			if @temp_response && @temp_response["total"] && @temp_response["total"] > 0
				@restaurant_list = @temp_response["businesses"].map { |item| item["name"] }.shuffle

				#select a random item
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
				#add message
				#"Oh no! We couldn't find a restaurant for you.  Try broadening your search criteria."
				render "new"
			end
		else
			render "new"
		end
	end

	private

	def get_address_for_geocode(item)
		address = item["location"]["address"].join(" ")
		address += " " + item["location"]["city"]
	end
end
