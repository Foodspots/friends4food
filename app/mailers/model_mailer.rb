class ModelMailer < ActionMailer::Base
  default from: "alerts@friends4food.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.model_mailer.new_record_notification.subject
  #
  def new_pin_notification(pin)
    @pin = pin
    mail to: pin.user.email, subject: "#{@pin.user.name}, your restaurant #{@pin.description} is added.", bcc: "oliviervanhees@gmail.com"
  end

  def new_like_notification(pin, follower, current_user)
    @pin = pin
    @follower = follower
    @current_user = current_user
    mail to: @follower.email, subject: "Your friend #{@current_user.name}, likes restaurant #{@pin.name}.", bcc: "oliviervanhees@gmail.com"
  end

  def new_follower_notification(user, current_user)
    @user = user
    @current_user = current_user
    mail to: user.email, subject: "#{@user.name}, you are now followed by #{current_user.name}.", bcc: "oliviervanhees@gmail.com"
  end

  def new_user_account_notification(user)
    @user = user
    mail to: @user.email, subject: "#{@user.name}, start now discovering your friends' favorites. ", bcc: "oliviervanhees@gmail.com"
  end

	def weekly_gps_report(user, top3)
		@user = user
		@top3 = top3
		mail to:@user.email, subject: 'Your weekly digest'
	end
end

