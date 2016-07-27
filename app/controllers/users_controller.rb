class UsersController < ApplicationController

  def index
    @users = User.all.sort_by(&:rating).reverse
  end

  def show
    @user = User.find(params[:id])
    @user_posts = Post.where(user_id: @user.id)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params.require(:user).permit(:name, :email, :password))
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path

      flash[:notice] = 'Your account was created'
    else
      redirect_to :back
      flash[:notice] = 'Please verify your data'
    end
  end

end
