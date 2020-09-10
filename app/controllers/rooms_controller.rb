class RoomsController < ApplicationController
  before_action :authenticate_user!
  def create
    @room = Room.create #フォームで送られてきた値を受取り部屋を作る
    @entry1 = Entry.create(:room_id => @room.id, :user_id => current_user.id) #部屋に入るための子モデルentryも作り。部屋に入るログインユーザーを保存。紐づく部屋のidと紐づくユーザーのid。
    @entry2 = Entry.create(params.require(:entry).permit(:user_id, :room_id).merge(:room_id => @room.id)) #相手側のユーザーも部屋に入る前のentryを作成。
    redirect_to "/rooms/#{@room.id}" #1行目のcreateで作られたチャットルームに移動
  end

  def show
    @room = Room.find(params[:id]) #上記で作られた部屋のidを表示するためにモデルから取り出す
    if Entry.where(:user_id => current_user.id, :room_id => @room.id).present? #もしentry部屋にentryテーブルのuser_idと紐づくログインユーザーとroom_idに紐づくroomsテーブルのroom.idが存在していれば
      @messages = @room.messages #roomでのメッセージを代入
      @message = Message.new #メッセージのインスタンス生成
      @entries = @room.entries #roomに入室しているentryテーブルのuse_idを代入
    else #entryテーブルに紐づいたユーザーが存在しなければ
      redirect_back(fallback_location: root_path) #前のページに戻る
    end
  end
end