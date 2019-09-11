class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chatroom
  def create
    message = @chatroom.messages.new(message_params)
    message.user = current_user
    message.save
    MessageRelayJob.perform_later(message)
  end
  def destroy
    @messages = Message.where(chatroom_id: @chatroom_id.id)
    @messages.destroy_all
  end
  private
    def set_chatroom
      @chatroom = Chatroom.find(params[:chatroom_id])
    end
    def message_params
      params.require(:message).permit(:body)
    end
end
