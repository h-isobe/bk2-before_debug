class MessagesController < ApplicationController
  before_action :authenticate_user!, :only => [:create]

  def create
    if Entry.where(:user_id => current_user.id, :room_id => params[:message][:room_id]).present? #もしentryモデルのuser_idと紐づくログインユーザーとroom_idと紐づくrooms/showで送られてきたコメントとroom_idが存在すれば
      @message = Message.create(params.require(:message).permit(:user_id, :content, :room_id).merge(:user_id => current_user.id)) #メッセージを作成。messageテーブルに送られてきた引数をmessageカラムに保存。ログインユーザーのidも混ぜて保存。
      redirect_to "/rooms/#{@message.room_id}"
    else #そうでなければ
      redirect_back(fallback_location: root_path) #前のページへ戻る
    end
  end
end