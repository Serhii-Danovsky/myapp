class CommentsController < ApplicationController
  before_action :check_comment_permission, only: [:update, :destroy]
  before_action :set_comment, only: [:update, :destroy]


  def index
  end


  def create
    @parent = Post.find(params[:post_id]) if params[:post_id]
    @parent = Comment.find(params[:comment_id]) if params[:comment_id]
    @comment = @parent.comments.new(comment_params)
    @comment.user_id = session[:user_id]
    @comment.save
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'The reply comment was successfully add.' }
      format.js
      format.json
    end
  end

  def update
    @comment.update(comment_params)
  end

  def new
    @parent_comment = Comment.find(params[:comment_id])
    @comment = @parent_comment.comments.new
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'The comment was successfully destroyed.' }
      format.js
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def check_comment_permission
    @comment = Comment.find(params[:id])
    unless @comment.user.id == session[:user_id]
      flash[:alert] = 'You have not permission!'
      redirect_to @comment.post
    end
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end
end
