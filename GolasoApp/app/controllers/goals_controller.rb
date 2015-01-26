class GoalsController < ApplicationController
  before_action :require_current_user!, only: [:new, :cheer, :create]
  before_action :require_owner!, only: [:edit, :update, :destroy, :complete]

  def index
    @goals = Goal.select('goals.*, COUNT(cheers.user_id) AS cheer_count').joins(:cheers).group('goals.id').order('COUNT(cheers.user_id) DESC').limit(10)
  end

  def new
    @goal = Goal.new
  end

  def create
    @goal = Goal.new(goal_params)
    @goal.owner_id = current_user.id
    if @goal.save
      redirect_to goal_url(@goal)
    else
      flash.now[:errors] = @goal.errors.full_messages
      render :new
    end
  end

  def show
    @goal = Goal.find(params[:id])
  end

  def edit
    @goal = Goal.find(params[:id])
  end

  def update
    @goal = Goal.find(params[:id])
    if @goal.update(goal_params)
      redirect_to goal_url(@goal)
    else
      flash.now[:errors] = @goal.errors.full_messages
      render :edit
    end
  end

  def destroy
    @goal = Goal.find(params[:id])
    @goal.destroy
    redirect_to user_url(@goal.owner)
  end

  def complete
    @goal = Goal.find(params[:id])
    @goal.toggle(:completed)
    @goal.save
    redirect_to goal_url(@goal)
  end

  def cheer
    @goal = Goal.find(params[:id])
    @cheer = Cheer.new(goal_id: params[:id], user_id: current_user.id)
    @cheer.save
    flash[:errors] = @cheer.errors.full_messages
    redirect_to goal_url(@goal)
  end

  private

  def goal_params
    params.require(:goal).permit(:title, :description, :status)
  end

  def require_owner!
    @goal = Goal.find(params[:id])
    redirect_to user_url(@goal.owner) unless current_user == @goal.owner
  end

end
