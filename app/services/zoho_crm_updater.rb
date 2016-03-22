require 'faraday'
class ZohoCrmUpdater
  HOST = 'https://crm.zoho.com'
  GET_RECORD_PATH = '/crm/private/json/Contacts/getRecordById'
  BASE_PARAMS = {
    authtoken: ENV['ZOHO_API_AUTH_TOKEN'],
    scope: 'crmapi'
  }

  attr_reader :conn
  def initialize
    @conn = Faraday.new(url: HOST)
  end

  def get_record(id)
    conn.get(GET_RECORD_PATH, BASE_PARAMS.merge(id: 123))
  end

end
