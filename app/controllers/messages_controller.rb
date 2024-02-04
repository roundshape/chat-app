class MessagesController < ApplicationController
  def index
    @message = Message.new
    # params[:room_id]は/rooms/:room_id/messagesから
    @room = Room.find(params[:room_id])

    @messages = @room.messages.includes(:user)
  end

  def create
    @room = Room.find(params[:room_id])
    @message = @room.messages.new(message_params)
    if @message.save
      redirect_to room_messages_path(@room)
    else
      @messages = @room.messages.includes(:user)
      render :index, status: :unprocessable_entity
    end
  end

  private

  def message_params
    #room_idが無いのは上のcreateメソッドで@roomにあり、フォームからは送られてこない
    params.require(:message).permit(:content).merge(user_id: current_user.id)
  end
end
