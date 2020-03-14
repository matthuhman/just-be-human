class SignaturesController < ApplicationController
  before_action :authenticate_user!

  def create
    waiver = Waiver.find(params[:signature][:waiver_id])
    opportunity = Opportunity.find(params[:signature][:opportunity_id])

    if (!waiver || !opportunity)
      redirect_to '/', alert: 'Waiver ID or Opportunity ID was invalid'
    end

    is_current_user = current_user.id == params[:signature][:user_id]
    is_follower = current_user.is_follower?(opportunity.id)
    waiver_hash = params[:signature][:waiver_hash]
    remote_ip = request.remote_ip

    if (!is_current_user || !is_follower || !remote_ip)
      redirect_to opportunity, alert: 'Signature did not have required information'
    end

    signature = Signature.new(waiver: waiver, user: current_user, opportunity: opportunity,#
     user_salt: current_user.authenticatable_salt, waiver_hash: waiver_hash, signer_ip: remote_ip)#

    if signature.create
      redirect_to opportunity, notice: 'Waiver was signed successfully'
    else
      ReportedError.report('Signature.create', signature.errors, 100)
      redirect_to opportunity, alert: 'Waiver was not signed successfully.'
    end
  end


  private

    def sign_params
      params.require(:signature).permit(:waiver_id, :opportunity_id, :user_id, :waiver_hash)
    end

end
