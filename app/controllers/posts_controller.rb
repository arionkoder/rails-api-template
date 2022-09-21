class PostsController < ApplicationController
  before_action :set_post, only: [:show, :update, :destroy]

  def index
    posts = Post.all
    render json: posts
  end

  def create
    @post = current_user.posts.build(create_params)
    if @post.save
      render json: @post, status: :created
    else
      render json: { message: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    authorize @post

    if @post.update(update_params)
      render json: @post, status: :ok
    else
      render json: { status: :unprocessable_entity, message: @post.errors.full_messages }
    end
  rescue Pundit::NotAuthorizedError
    render json: { message: "Not allowed to update another person Post"}, status: :unauthorized
  end

  def destroy
    authorize @post

    if @post.destroy
      render json: { message: "Post deleted" }, status: :ok
    else
      render json: { status: :unprocessable_entity, message: @post.errors.full_messages }
    end
  rescue Pundit::NotAuthorizedError
    render json: { message: "Not allowed to delete another person Post"}, status: :unauthorized
  end

  def show
    render json: @post
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def create_params
    params.require(:post).permit(:title, :content)
  end

  def update_params
    params.require(:post).permit(:title, :published, :content)
  end
end
