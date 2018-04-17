class PrivateChatRoomsController < ApplicationController

  def new
    @room = PrivateChatRoom.new
  end

  def show
    @private_chat_room = PrivateChatRoom.find(params[:id])
    @owner = @private_chat_room.membership.owner

    # @member = @private_chat_room.membership.member
  end

  def index
    @rooms_owner = Membership.where(owner_id: current_user.id)
    @rooms_member = Membership.where(member_id: current_user.id)
    @room = PrivateChatRoom.new
  end

  def create
    @room = PrivateChatRoom.new(private_chat_room_params)
    if @room.save
      redirect_to private_chat_room_path(@room)
    else
      flash[:error] = @room.errors.full_messages.to_sentence
      redirect_to private_chat_rooms_path
    end
  end

  def search
    if params[:username].nil?
      @users = []
    else
      @users = User.search params[:username]
    end
    @room = PrivateChatRoom.new
    @room.build_membership
  end

  private

  def private_chat_room_params
    params.require(:private_chat_room).permit(:name, membership_attributes: [:owner_id, :member_id])
  end
end
