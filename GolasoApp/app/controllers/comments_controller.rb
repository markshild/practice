class CommentsController < ApplicationController
  before_action :require_current_user!, only: :create

  def create
    @comment = Comment.new(comment_params)
    @comment.author_id = current_user.id
    parent = @comment.commentable_type.to_s.downcase
    if @comment.save
      redirect_to send("#{parent}_url", @comment.commentable_id)
    else
      flash[:errors] = @comment.errors.full_messages
      redirect_to send("#{parent}_url", @comment.commentable_id)
    end

  end

  def destroy

  end

  private
  def comment_params
    params.require(:comment).permit(:body, :commentable_id, :commentable_type)
  end
end
