class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
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
