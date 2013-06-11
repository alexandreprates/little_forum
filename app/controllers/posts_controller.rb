class PostsController < ApplicationController

  def index
    @posts = Post.topics.page(params[:page])
  end
  
  def show
    @post = Post.find(params[:id])
    @replies = @post.replies.page(params[:page])
  end
  
  def create
    @post = Post.new(params[:post])
    if @post.save
      redirect_to :back
    else
      render :index
    end
  end

end
