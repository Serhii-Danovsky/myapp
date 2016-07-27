class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token
  def current_user
    current_user ||= User.find(session[:user_id]) if session[:user_id]
  end


  def test_user
    name_json = params[:name]
    email_json = params[:email]
    @resource = User.create!({:email => email_json, :password => "111111", :password_confirmation => "111111"  , :name => name_json})

    if @resource.save
      render json: {
          confirm: 'сохранен',
      }, status: :ok
    else
      render json: @resource.errors, status: :unprocessable_entity
    end
  end



  def favorite_post?(post)
    current_user.favorite_posts.where(post_id: post.id).present?
  end

  helper_method :current_user
  helper_method :favorite_post?
end
