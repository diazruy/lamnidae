require 'net/http'
require 'json'
require 'yaml'
require 'csv'

class EpicureExporter
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

  attr_reader :csv
  def initialize
    page = 1
    customers = []
    while (customer_data = get_page(page)).size > 0 do
      customers += customer_data
      page += 1
    end

    @csv = CSV.generate do |csv|
      csv << FIELDS
      customers.each do |customer|
        csv << FIELDS.collect {|f| customer[f]}
      end
    end
  end

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


