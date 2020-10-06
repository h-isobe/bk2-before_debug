class Book < ApplicationRecord
	belongs_to :user
	has_many :favorites, dependent: :destroy
	has_many :book_comments, dependent: :destroy
	has_many :notifications, dependent: :destroy
	has_many :book_images, dependent: :destroy
  accepts_attachments_for :book_images, attachment: :image
	#バリデーションは該当するモデルに設定する。エラーにする条件を設定できる。
	#presence trueは空欄の場合を意味する。
	validates :title, presence: true
	validates :body, presence: true, length: {maximum: 200}
	is_impressionable

	def favorited_by?(user)
		favorites.where(user_id: user.id).exists?
	end

	def Book.search(search, user_or_book, how_search)
		if user_or_book == "2"
			if how_search == "1"
				Book.where(['title LIKE ?', "#{search}"])
			elsif how_search == "2"
				Book.where(['title LIKE ?', "#{search}%"])
			elsif how_search == "3"
				Book.where(['title LIKE ?', "%#{search}"])
			elsif how_search == "4"
				Book.where(['title LIKE ?', "%#{search}%"])
		  else
				Book.all
			end	
		end
	end

	def create_notification_favorite!(current_user)
    temp = Notification.where(["visitor_id = ? and visited_id = ? and book_id = ? and action = ? ",current_user.id, user_id, id, 'favorite'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        book_id: id,
        visited_id: user_id,
        action: 'favorite'
      )

      if notification.visitor_id == notification.visited_id
         notification.checked = true
      end
      notification.save if notification.valid?
    end
	end
	
	def create_notification_book_comment!(current_user, book_comment_id)
    #同じ投稿にコメントしているユーザーに通知を送る。（current_userと投稿ユーザーのぞく）
    temp_ids = BookComment.where(book_id: id).where.not("user_id=? or user_id=?", current_user.id,user_id).select(:user_id).distinct
    #取得したユーザー達へ通知を作成。（user_idのみ繰り返し取得）
    temp_ids.each do |temp_id|
      save_notification_book_comment!(current_user, book_comment_id, temp_id['user_id'])
    end
    #投稿者へ通知を作成
    save_notification_book_comment!(current_user, book_comment_id, user_id)
  end

  def save_notification_book_comment!(current_user, book_comment_id, visited_id)
    notification = current_user.active_notifications.new(
      book_id: id,
      book_comment_id: book_comment_id,
      visited_id: visited_id,
      action: 'book_comment'
    )
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end

end
