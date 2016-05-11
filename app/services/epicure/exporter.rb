require 'net/http'
require 'json'
require 'yaml'
require 'csv'

module Epicure
  class Exporter
    URI = URI(ENV['EPICURE_URL'])
    FIELDS = %w{
      FirstName
      LastName
      Email
      Phone
      Street
      City
      ProvinceStateCode
      CountryCode
      PostalZipCode
      Note
      ShippingInstructions
    }

    def initialize

    end

    def csv
      @csv = CSV.generate do |csv|
        csv << Epicure::Customer::FIELDS
        customers.each do |customer|
          csv << Epicure::Customer::FIELDS.collect {|f| customer[f]}
        end
      end
    end

    def customers
      return @customers if @customers
      page = 1
      @customers = []
      while (customer_data = get_page(page)).size > 0 do
        customer_data.each do |customer|
          @customers << Epicure::Customer.new(customer)
        end
        page += 1
      end
      @customers
    end

    private

    def get_page(page)
      params = {
        'Page' => page,
        'PerPage' => 50,
        'Sort' => 1,
        'Ascending' => true,
        'Search' => ""
      }
      req = Net::HTTP::Post.new(URI)
      req.body = params.to_json
      res = Net::HTTP.start(URI.hostname, URI.port) do |http|
        http.request(req)
      end
      json = JSON.parse(res.body)
      customers = json['d']['Customers']
    end
  end
end
