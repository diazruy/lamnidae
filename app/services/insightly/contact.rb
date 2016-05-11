module Insightly
  class Contact
    extend Forwardable

    ATTRIBUTES = %i{
      first_name
      last_name
      email
      phone
      street
      city
      province
      country
      postal_code
    }

    attr_reader :data

    def initialize(data)
      @data = data
    end

    def_delegators :data, :first_name, :last_name, :contact_id

    def address(field)
      @address ||= data.addresses.first
      value = @address && @address[field]
      value.blank? ? nil : value
    end

    def street
      address('street')
    end

    def city
      address('city')
    end

    def postal_code
      address('postcode')
    end

    def province
      address('state')
    end

    def country
      case country_code = address('country')
      when 'CA' then 'Canada'
      else country_code
      end
    end

    def email
      contact_info('email')
    end

    def phone
      contact_info('phone')
    end

    def contact_info(type)
      @contact_info ||= data.contactinfos
      @contact_info.find do |info|
        info['type'] == type.upcase
      end.try(:[], 'detail')
    end

    def ==(customer)
      customer.first_name == first_name &&
        customer.last_name == last_name &&
        customer.phone == phone &&
        customer.street == street &&
        customer.province == province &&
        customer.postal_code == postal_code
    end
  end

end
