require 'insightly2'
module Insightly
  class Importer

    attr_reader :client
    def initialize
      Insightly2.api_key = ENV['INSIGHTLY_API_KEY']
      @client = Insightly2.client
    end

    def contacts
      client.get_contacts.collect do |contact|
        Insightly::Contact.new(contact)
      end
    end

    def update(id, epicure)
      client.update_contact(contact: contact_attributes(epicure).merge(
        contact_id: id
      ))
    end

    def create(epicure)
      client.create_contact(contact: contact_attributes(epicure))
    end

    private

    def contact_attributes(epicure)
      contactinfos = []
      contactinfos << {type: 'EMAIL', detail: epicure.email, label: 'Work'} if epicure.email.present?
      contactinfos << {type: 'PHONE', detail: epicure.phone, label: 'Work'} if epicure.phone.present?
      addresses = []
      if epicure.street.present?
        addresses << {
          address_type: "Postal",
          street: epicure.street,
          city: epicure.city,
          state: epicure.province,
          postcode: epicure.postal_code,
          country: "CA"
        }
      end

      {
        first_name: epicure.first_name,
        last_name: epicure.last_name,
        contactinfos: contactinfos,
        addresses: addresses
      }
    end
  end
end
