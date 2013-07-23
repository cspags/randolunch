class Search
	include ActiveModel::Validations
	include ActiveModel::Conversion
	extend ActiveModel::Naming

	attr_accessor :search_term, :location

	validates :location, presence: true

	def initialize(attributes = {})
		attributes.each do |name, value|
			send("#{name}=", value)
		end
	end

	def persisted?
		false
	end
end