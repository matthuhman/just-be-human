class PersonalMessagesController < ApplicationController





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


  # before_action :find_conversation!

  # def create

  #   if Conversation.can_have_conversation(current_user, @receiver)
  #     @conversation ||= Conversation.create(author_id: current_user.id,
  #                                           receiver_id: @receiver.id)
  #     @personal_message = current_user.personal_messages.build(personal_message_params)
  #     @personal_message.conversation_id = @conversation.id

  #     if @personal_message.save
  #       flash[:success] = "Your message was sent!"
  #       redirect_to conversation_path(@conversation)
  #     else
  #       flash[:alert] = "Your message was not sent!"
  #       redirect_to conversation_path(@conversation)
  #     end
  #   else
  #     flash[:alert] = "#{@receiver.username} is not accepting private messages at this time."
  #     redirect_to root_path
  #   end
  # end

  # def new
  #   redirect_to conversation_path(@conversation) and return if @conversation
  #   @personal_message = current_user.personal_messages.build
  # end

  # private

  # def personal_message_params
  #   params.require(:personal_message).permit(:body)
  # end

  # def find_conversation!
  #   if params[:receiver_id]
  #     @receiver = User.find_by(id: params[:receiver_id])
  #     redirect_to(root_path) and return unless @receiver
  #     @conversation = Conversation.between(current_user.id, @receiver.id)[0]
  #   else
  #     @conversation = Conversation.find_by(id: params[:conversation_id])
  #     @receiver = @conversation.receiver
  #     redirect_to(root_path) and return unless @conversation && @conversation.participates?(current_user)
  #   end
  # end

end
