class CatsController < ApplicationController
  # Allow unlogged in users to browse cats.
  before_action :require_user!, only: %i(new create edit update)

  def index
    @cats = Cat.all
    render :index
  end

  def show
    @cat = Cat.find(params[:id])
    render :show
  end

  def new
    @cat = Cat.new
    render :new
  end

  def create
    @cat = current_user.cats.new(cat_params)
    # debugger
    if @cat.save
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :new
    end
  end

  def edit
    @cat = current_user.cats.find(params[:id])
    # debugger
    render :edit
  end

  def update
    @cat = current_user.cats.find(params[:id])
    # debugger
    if @cat.update_attributes(cat_params)
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :edit
    end
  end

  private

  def cat_params
    params.require(:cat)
      .permit(:birth_date, :color, :description, :name, :sex)
  end
end
