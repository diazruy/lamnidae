class EpicureController < ApplicationController
  before_filter :authenticate_user!

  def index
    @epicure_customers = epicure_api.customers
    @insightly_contacts = insightly_api.contacts
  end

  def update
    emails = params[:contact] || []
    insightly_contacts = insightly_api.contacts
    epicure_customers = epicure_api.customers
    errors = []
    emails.each do |email|
      epicure = epicure_customers.find {|customer| customer.email == email}
      insightly = insightly_contacts.find {|contact| contact.email == epicure.email}

      begin
        if insightly.present?
          insightly_api.update(insightly.contact_id, epicure)
        else
          insightly_api.create(epicure)
        end
      rescue Insightly2::Errors::ClientError => e
        errors << [epicure.email, e.response.body].join(': ')
      end
    end
    flash[:error] = errors.join("\n") if errors.present?
    redirect_to epicure_url(epicure_headers: params[:epicure_headers])
  end

  private

  def insightly_api
    @insightly_api ||= Insightly::Importer.new(current_user.integration_keys.insightly)
  end

  def epicure_token
    epicure_header('RequestVerificationToken')
  end

  def epicure_cookie
    epicure_header('Cookie')
  end

  def epicure_header(name)
    return nil unless params[:epicure_headers].present?
    token_line = params[:epicure_headers].split("\n").find {|line| line.starts_with?(name) }
    parts = token_line.split(' ')
    parts.shift
    parts.join(' ')
  end

  def epicure_api
    @epicure_api ||= Epicure::Exporter.new(epicure_cookie, epicure_token)
  end
end
