class UserMailer < ApplicationMailer
  default from: "maudcharta@gmail.com"

  def signup_confirmation(user)
    @user = user
    mail to: user.email, subject: "Welkom bij appeldep app"
  end

end