class SessionsController < ApplicationController
  def login
  end

  def create
    @user = User.find_by_email(params[:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:notice]='You successful login'
      redirect_to root_path

    else
      flash[:notice]='Invalid email or password'
      redirect_to :back
    end
  end

  def logout
    reset_session
    redirect_to root_path
    flash[:notice]='You successful logout'
  end
end
