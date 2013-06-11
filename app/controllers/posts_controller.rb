class PostsController < ApplicationController

  def index
    @posts = Post.topics.page(params[:page])
    @post = Post.new
  end
  
  def show
    @post = Post.find(params[:id])
    @replies = @post.replies.page(params[:page])
  end
  
  def create
    @post = Post.create(params[:post])
    redirect_to :back
  end

end
