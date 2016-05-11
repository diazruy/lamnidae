module Epicure
  class Customer

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

    attr_reader :data
    def initialize(data)
      @data = data
    end

    def first_name
      clean_data('FirstName')
    end

    def last_name
      clean_data('LastName')
    end

    def email
      clean_data('Email')
    end

    def phone
      clean_data('Phone')
    end

    def street
      clean_data('Street')
    end

    def city
      clean_data('City')
    end

    def province
      clean_data('ProvinceStateCode')
    end

    def country
      clean_data('CountryCode')
    end

    def postal_code
      clean_data('PostalZipCode')
    end

    private

    # Return nil if value is ""
    def clean_data(field)
      data[field].present? ? data[field] : nil
    end
  end
end
