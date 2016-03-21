class EpicureController < ApplicationController
  before_filter :authenticate

  def index
    send_data EpicureExporter.new.csv, filename: "contacts-#{Time.now.strftime('%Y-%m-%d')}.csv"
  end

  private

  def authenticate
    authentication = authenticate_with_http_basic do |u, p|
      creds = ENV['BASIC_AUTH'].split(':')
      [u, p] == creds
    end
    unless authentication
      request_http_basic_authentication
    end
  end
end
