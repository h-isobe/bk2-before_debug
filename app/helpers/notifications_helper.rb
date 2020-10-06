module NotificationsHelper
  def notification_form(notification)
    #通知を送ってきたユーザーを取得
    @visitor = notification.visitor
    #コメントの内容を通知に表示する
    @comment = nil
    @visitor_comment = notification.book_comment_id
    # notification.actionがfollowかlikeかcommentかで処理を変える
    case notification.action
    when 'follow'
      #aタグで通知を作成したユーザーshowのリンクを作成
      tag.a(notification.visitor.name, href: user_path(@visitor)) + 'があなたをフォローしました'
    when 'favorite'
      tag.a(notification.visitor.name, href: user_path(@visitor)) + 'が' + tag.a('あなたの投稿', href: book_path(notification.book_id)) + 'にいいねしました'
    when 'book_comment' then
      #コメントの内容と投稿のタイトルを取得　      
      @comment = BookComment.find_by(id: @visitor_comment)  
      @comment_content =@comment.content
      @book_title =@comment.book.title
      tag.a(@visitor.name, href: user_path(@visitor)) + 'が' + tag.a("#{@book_title}", href: book_path(notification.book_id)) + 'にコメントしました'
    end
  end

  def unchecked_notifications
    @notifications = current_user.passive_notifications.where(checked: false)
  end
end
