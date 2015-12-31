class SessionsController < ApplicationController

  def new
  end

  def create
    #authenticate before saving. :authenticate method
    # comes with has_secure_password
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      log_in(user)
      redirect_to user
    else
      flash.now.alert = "Inloggen mislukt. Nog eens proberen?"
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Je bent uitgelogd"
  end
end