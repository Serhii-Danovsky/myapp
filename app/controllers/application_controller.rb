class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def favorite_post?(post)
    current_user.favorite_posts.where(post_id: post.id).present?
  end

  helper_method :current_user
  helper_method :favorite_post?
end
