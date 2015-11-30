class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  after_action :update_views
  before_action :check_permissions, only: [:edit, :update, :destroy]
  require 'will_paginate/array'
  # GET /posts
  # GET /posts.json
  def index
    if params[:query].present?
      @posts = Post.where('body LIKE ? or title LIKE ? or  tags LIKE ? ',
                          "%#{params[:query]}%", "%#{params[:query]}%", "%#{params[:query]}%").newest
    else
      @posts = Post.paginate(:page => params[:page], :per_page => 5).index_tags(params)

      respond_to do |format|
        format.html
        format.json
        format.csv { send_data @posts.to_csv }
        format.xls # { send_data @posts.to_csv(col_sep: "\t") }
      end
    end
  end

  def votes
    @post = Post.find(params[:post_id])
    if params[:vote] == '+'
      @post.upvote_from current_user
    elsif params[:vote] == '-'
      @post.downvote_from current_user
    end
  end

  def check_permissions
    unless @post.user == current_user
      redirect_to root_path, notice: 'Action applies only to your posts !'
    end
  end

  def count
    @post = Post.find(params[:post_id])
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @comments = @post.comments
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  def showalluserpost
    if current_user
      @user = User.find(current_user.id)
      @posts = @user.posts.paginate(:page => params[:page], :per_page => 3)
    else
      redirect_to posts_path, notice: 'Login or register'
    end
  end

  # POST /posts
  # POST /posts.json
  def create

    if current_user
      @post = Post.new(post_params)
      respond_to do |format|
        if @post.save
          format.html { redirect_to @post, notice: 'Post was successfully created.' }
          format.json { render :show, status: :created, location: @post }
        else
          format.html { render :new }
          format.json { render json: @post.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to posts_path, notice: 'Login or register to create post'
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    if current_user && current_user.id == @post.user.id
      respond_to do |format|
        if @post.update(post_params)
          format.html { redirect_to @post, notice: 'Post was successfully updated.' }
          format.json { render :show, status: :ok, location: @post }
        else
          format.html { render :edit }
          format.json { render json: @post.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to posts_path, notice: 'You dont have permission to update post.'
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    if current_user && current_user.id == @post.user.id
      @post.destroy
      respond_to do |format|
        format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      redirect_to posts_path, notice: 'You dont have permission to delete post.'
    end
  end

  def popular
    @posts = Post.popular(Post.all).paginate(:page => params[:page], :per_page => 3)
  end

  def active
    @posts = Post.active.paginate(:page => params[:page], :per_page => 3)
  end

  def add_to_favorite
    post = Post.find(params[:id])
    unless favorite_post?(post)
      FavoritePost.create!(post_id: post.id, user_id: current_user.id)
    end

    redirect_to :back
  end

  def remove_from_favorite
    post = Post.find(params[:id])
    if favorite_post?(post)
      current_user.favorite_posts.find_by(post_id: post.id).destroy
    end

    redirect_to :back
  end

  def favorite
    @posts = current_user.favorite_posts.map(&:post).paginate(:page => params[:page], :per_page => 3)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def post_params
    params.require(:post).permit(:title, :body, :tags, :image).merge(user_id: current_user.id)
  end

  def update_views
    cookies[:views] =
        if cookies[:views].present?
          cookies[:views].to_i + 1
        else
          1
        end
  end
end
