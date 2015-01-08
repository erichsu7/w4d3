class CatsController < ApplicationController
  before_action :current_user_owns_cat, only: [:edit, :update]

  def index
    @cats = Cat.all
    render :index
  end

  def show
    @cat = Cat.find(params[:id])
    @crrs = @cat.cat_rental_requests.order(:start_date, :end_date)
    render :show
  end

  def edit
    @cat = Cat.find(params[:id])

    render :edit
  end

  def new
    @cat = Cat.new
    render :new
  end

  def create
    @cat = Cat.new(cat_params)
    @cat.user_id = current_user.id

    if @cat.save
      redirect_to cat_url(@cat)
    else
      render :new
    end
  end

  def update
    @cat = Cat.find(params[:id])

    if @cat.update(cat_params)
      redirect_to cat_url(@cat)
    else
      render :edit
    end
  end

  private

  def cat_params
    params.require(:cat).permit(:name, :birth_date, :color, :sex, :description)
  end

  def current_user_owns_cat
    @cat = Cat.find(params[:id])

    unless @cat.user_id == current_user.id
      redirect_to cat_url(@cat)
    end
  end

end
