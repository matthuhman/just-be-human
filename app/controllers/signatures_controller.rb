class SignaturesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:callbacks]

  def create
    embedded_request = create_embedded_request(name: params[:name], email: params[:email])
    @sign_url = get_sign_url(embedded_request)
    render :embedded_signature
  end

  private

  def create_embedded_request(opts = {})
    HelloSign.create_embedded_signature_request(1,
      client_id: ENV['HELLOSIGN_CLIENT_ID'],
      subject: 'My first embedded signature request',
      message: 'Awesome, right?',
      signers: [
        {email_address: opts[:email],
          name: opts[:name]}
      ],
      files: ['offer_letter.pdf']
    )
  end

  def get_sign_url(embedded_request)
    sign_id = get_first_signature_id(embedded_request)
    HelloSign.get_embedded_sign_url(signature_id: sign_id).sign_url
  end

  def get_first_signature_id(embedded_request)
    embedded_request.signatures[0].signature_id
  end


  def callbacks
    render json: 'Hello API Event Received', status: 200
  end
end
