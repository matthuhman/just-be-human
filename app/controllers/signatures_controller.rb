class SignaturesController < ApplicationController
  before_action :authenticate_user!

  def create
    waiver = Waiver.find(params[:signature][:waiver_id])
    opportunity = Opportunity.find(params[:signature][:opportunity_id])

    if (!waiver || !opportunity)
      # TODO: redirect to home page
      binding.pry
    end

    is_current_user = current_user.id == params[:signature][:user_id]
    is_follower = current_user.is_follower?(opportunity.id)
    waiver_hash = params[:signature][:waiver_hash]
    remote_ip = request.remote_ip

    if (!is_current_user || !is_follower || !remote_ip)
      # TODO: redirect to opportunity page
      binding.pry
    end

    signature = Signature.new(waiver: waiver, user: current_user, opportunity: opportunity,#
     user_salt: user.authenticatable_salt, waiver_hash: waiver_hash, signer_ip: remote_ip)#

    if signature.create
      # redirect to oppo page

    else
      # redirect to oppo page w/ error message

    end


  end


  private

    def sign_params
      params.require(:signature).permit(:waiver_id, :opportunity_id, :user_id, :waiver_hash)
    end

end
