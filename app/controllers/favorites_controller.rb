class FavoritesController < ApplicationController
  
  def create
    @book = Book.find(params[:book_id])
    @favorite = current_user.favorites.new(book_id: @book.id)
    @favorite.save
    @book.create_notification_favorite!(current_user)
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_url) }
      format.js
    end
  end

  def destroy
    @book = Book.find(params[:book_id])
    @favorite = current_user.favorites.find_by(book_id: @book.id)
    @favorite.destroy
  end
end
