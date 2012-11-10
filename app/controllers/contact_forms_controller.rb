class ContactFormsController < ApplicationController
  def create
    form = ContactForm.new(params[:contact_form])
    if form.deliver
      respond_to do |f|
        f.json { render json: {message: 'Thank you! I will get back to you shortly' } }
      end
    else
      respond_to do |f|
        f.json { render json: {
          errors: form.errors.full_messages
        } ,
        status: :unprocessable_entity}
      end
    end
  end
end
