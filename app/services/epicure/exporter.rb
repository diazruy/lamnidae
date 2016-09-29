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

    attr_reader :cookie, :token

    def initialize(cookie, token)
      @cookie = cookie
      @token = token
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
      while (customer_data = get_page(page)).size > 0 && page < 10 do
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
        Page: page,
        PerPage: 50,
        Sort: 1,
        Ascending: true,
        Search: ""
      }
      http = Net::HTTP.new(URI.host, URI.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      req = Net::HTTP::Post.new(URI)
      req.body = params.to_json
      req['Cookie'] = cookie
      req['RequestVerificationToken'] = token
      req.set_form_data(params)
      res = http.request(req)
      json = JSON.parse(res.body)
      customers = json['Customers'] || []
    end
  end
end
