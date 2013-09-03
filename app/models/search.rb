class Search
	include ActiveModel::Validations
	include ActiveModel::Conversion
	extend ActiveModel::Naming

	attr_accessor :search_term, :location, :distance, :distance_unit

	validates :location, presence: true
	validates :distance, presence: true
	validates :distance_unit, presence: true

	def initialize(attributes = {})
		attributes.each do |name, value|
			send("#{name}=", value)
		end
	end

	def persisted?
		false
	end
end