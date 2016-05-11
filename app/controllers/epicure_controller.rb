class EpicureController < ApplicationController
  before_filter :authenticate

  def index
    @epicure_customers = epicure_api.customers
    @insightly_contacts = insightly_api.contacts
  end

  def update
    emails = params[:contact]
    insightly_api
    insightly_contacts = insightly_api.contacts
    errors = []
    epicure_api.customers.each do |epicure|
      if emails.include?(epicure.email)
        if insightly = insightly_contacts.find {|contact| contact.email == epicure.email}
          begin
            insightly_api.update(insightly.contact_id, epicure)
          rescue Insightly2::Errors::ClientError => e
            errors << [epicure.email, e.response.body].join(': ')
          end
        else
          begin
            insightly_api.create(epicure)
          rescue Insightly2::Errors::ClientError => e
            errors << [epicure.email, e.response.body].join(': ')
          end
        end
      end
    end
    flash[:error] = errors.join("\n") if errors.present?
    redirect_to epicure_url
  end

  private

  def insightly_api
    @insightly_api ||= Insightly::Importer.new
  end

  def epicure_api
    @epicure_api ||= Epicure::Exporter.new
  end

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
