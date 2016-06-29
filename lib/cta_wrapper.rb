require 'httparty'
require 'csv'

class CTAWrapper
  include HTTParty
  base_uri 'http://lapi.transitchicago.com/api/1.0/'

  attr_reader :stops

  def initialize(key)
    @default_options = { query: {} }
    self.class.default_params key: key

    @stops = CSV.read("data/cta_locations.csv", headers: true, header_converters: :symbol).map(&:to_hash)
  end

  def arrivals(options = @default_options)
    self.class.get("/ttarrivals.aspx?", options)
  end
end