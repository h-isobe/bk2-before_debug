class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id]) #例）id:2のshowページとする。
    @books = @user.books
    @book = Book.new
    @currentUserEntry=Entry.where(user_id: current_user.id) #Entryモデルのuser_idに紐づくログインユーザーのidを取得。id:1とする。
    @userEntry=Entry.where(user_id: @user.id) #Entryモデルのuser_idと紐づく1行目の@userのidを取得。id:2とする。
    if @user.id == current_user.id #もしユーザーが同じなら何も起こらない。
    else #そうでなく異なれば
      @currentUserEntry.each do |cu| #各ログインユーザーを1人ずつ取り出す
        @userEntry.each do |u| #各相手側のユーザーを取り出す
          if cu.room_id == u.room_id then #もし紐づくroom_idが同じroom_idであれば
            @isRoom = true #チャット部屋がある
            @roomId = cu.room_id #ログインユーザーは@userのチャット部屋に入室できる
          end
        end
      end
      if @isRoom #もし2人のチャット部屋あれば
      else #そうでなくなければ
        @room = Room.new #新しく部屋を作る
        @entry = Entry.new #新しく@userの入室前の部屋を作る
      end
    end
  end

  def index
    @users = User.all
    @book = Book.new
  end
  
  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render "edit"
    end
  end

  def follower
    @user = User.find(params[:id])
  end

  def followed
    @user = User.find(params[:id])
  end

  def search
    @user_or_book = params[:option]
    @how_search = params[:choice]

    if @user_or_book == "1"
      @users = User.search(params[:search], @user_or_book, @how_search)
    else
      @books = Book.search(params[:search], @user_or_book, @how_search)
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
