class ConversationsController < ApplicationController

  # before_action :authenticate_user!
  # # ...
  # before_action :set_conversation, except: [:index]
  # before_action :check_participating!, except: [:index]

  ##################################################
#####################
#####################
#####################
#####################
##################### =>  20201205 abandoned
#####################
#####################
#####################
#####################
#####################
##################################################

  # def show
  #   @personal_message = PersonalMessage.new
  # end

  # def index
  #   @conversations = Conversation.participating(current_user).order("updated_at DESC")
  # end

  # private

  # def set_conversation
  #   @conversation = Conversation.find_by(id: params[:id])
  # end

  # def check_participating!
  #   redirect_to root_path unless @conversation && @conversation.participates?(current_user)
  # end

end
