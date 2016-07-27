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

  def test_user
    name_json = params[:name]
    User.create!({:email => "#{rand(1..9999)}guy@gmail.com", :password => "111111", :password_confirmation => "111111"  , :name => name_json})
  end
end
