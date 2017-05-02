require './lib/monkey_patch/hash'
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

    def update(contact, epicure)
      contact_data = contact_attributes(epicure).merge(
        contact_id: contact.contact_id
      )
      contact_data[:contactinfos].each do |ci|
        type = ci[:type]
        id = contact.contact_info_id(type)
        ci[:contact_info_id] = id if id
      end
      contact_data[:addresses][0][:address_id] = contact.address_id if contact.address_id
      client.update_contact(contact: contact_data)
    end

    def create(epicure)
      client.create_contact(contact: contact_attributes(epicure))
    end

    private

    def contact_attributes(epicure)
      contactinfos = []
      if epicure.email.present?
        contactinfos << {
          type: 'EMAIL',
          detail: epicure.email,
          label: 'Work'
        }
      end
      if epicure.phone.present?
        contactinfos << {
          type: 'PHONE',
          detail: epicure.phone,
          label: 'Work'
        }
      end

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
