class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.signup_confirmation(@user).deliver
      log_in(@user)
      redirect_to @user
    else
      render "new" #todo change to better ending
    end
  end


private

  def user_params
   params.require(:user).permit(:email, :password, :password_confirmation)
  end

end