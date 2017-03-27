require 'insightly2'
module Insightly
  class Importer

    attr_reader :client
    def initialize(api_key)
      @client = Insightly2::Client.new(api_key)
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

      {
        first_name: epicure.first_name,
        last_name: epicure.last_name,
        contactinfos: contactinfos,
        addresses: [{
          address_type: "Postal",
          street: epicure.street,
          city: epicure.city,
          state: epicure.province,
          postcode: epicure.postal_code,
          country: "Canada"
        }]
      }
    end
  end
end
