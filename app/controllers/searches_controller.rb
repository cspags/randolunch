include Yelp::V2::Search::Request

class SearchesController < ApplicationController

	def new
		client = Yelp::Client.new
		

		request = Location.new(
			term: "french", 
			city: "Chicago",
			consumer_key: ENV['RANDOLUNCH_YELP_CONSUMER_KEY'],
			consumer_secret: ENV['RANDOLUNCH_YELP_CONSUMER_SECRET'],
			token: ENV['RANDOLUNCH_YELP_TOKEN'],
			token_secret: ENV['RANDOLUNCH_YELP_TOKEN_SECRET'],
			response_format: Yelp::ResponseFormat.new(:name => 'json'))
		response = client.search(request)
		@yelp_response = response#.map{|k,v| "#{k}=#{v}"}.join('&')
	end

	def create
	end
end
