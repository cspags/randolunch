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
			@restaurant_list = @temp_response["businesses"].map { |item| item["name"] }.shuffle

			#select a random item
			selected_item = @temp_response["businesses"]
				.select { |item| item["name"] == @restaurant_list.sample }.first

			unless selected_item.nil?
				@winner = {
					name: selected_item["name"],
					rating_img_url: selected_item["rating_img_url"],
					rating: selected_item["rating"],
					url: selected_item["url"]
				}.to_json
			end

			@restaurant_list = @restaurant_list.to_json

		else
			render "new"
		end
	end
end
