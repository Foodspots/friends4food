class ModelMailer < ActionMailer::Base
  default from: "alerts@foodspots.me"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.model_mailer.new_record_notification.subject
  #

  def new_follower_notification(user, current_user)
    @user = user
    @current_user = current_user
    mail to: "oliviervanhees@gmail.com", subject: "#{@user.name}, you are now followed by #{current_user.name}.", bcc: "foodspotsjeroen@gmail.com"
  end

  def new_user_account_notification(user)
    @user = user
    mail to: @user.email, subject: "#{@user.name}, start now discovering your friends' favorites. ", bcc: "oliviervanhees@gmail.com"
  end

  def weekly_gps_report(user, top3)
    @user = user
    @top3 = top3
    mail to:@user.email, subject: "#{@user.name}, we have some personal news for you.", bcc: "oliviervanhees@gmail.com"
  end

    def weekly_friend_like_report(user, top3)
    @user = user
    @top3 = top3
    mail to:@user.email, subject: "#{@user.name}, discover your friends' favorite flavour", bcc: "oliviervanhees@gmail.com"
  end

end

