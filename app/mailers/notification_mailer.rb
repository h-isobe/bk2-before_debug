class NotificationMailer < ApplicationMailer

  def send_mail(user)
    @user = user
    mail to: user.email, subject:"新規登録完了のご連絡"
  end
end
