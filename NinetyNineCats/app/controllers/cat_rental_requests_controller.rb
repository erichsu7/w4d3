class CatRentalRequestsController < ApplicationController
  before_action :current_user_owns_cat, only: [:approve, :deny]

  def new
    @cats = Cat.all
    render :new
  end

  def create
    @crr = CatRentalRequest.new(crr_params)
    @crr.user_id = current_user.id

    if @crr.save
      flash.notice = "Rental request for cat \"#{Cat.find(@crr.cat_id).name}\" created!"
      redirect_to cat_rental_request_url(@crr)
    else
      #flash.notice = "Rental request for cat \"#{Cat.find(@crr.cat_id).name}\" failed!"
      flash.notice = @crr.errors.full_messages
      @cats = Cat.all
      render :new
    end
  end

  def show
    @crr = CatRentalRequest.includes(:cat).find(params[:id])

    render :show
  end

  def approve
    @crr = CatRentalRequest.find(params[:id])
    if @crr.approve!
      flash.notice = "Rental request approved!"
      redirect_to cat_url(@crr.cat_id)
    else
      flash.notice = @crr.errors.full_messages
      redirect_to cat_url(@crr.cat_id)
    end

  end

  def deny
    @crr = CatRentalRequest.find(params[:id])
    @crr.deny!
    redirect_to cat_url(@crr.cat_id)
  end

  private

  def crr_params
    params.require(:cat_rental_request)
      .permit(:cat_id, :start_date, :end_date, :status)
  end

  def current_user_owns_cat
    @crr = CatRentalRequest.find(params[:id])
    @cat = @crr.cat

    unless @cat.user_id == current_user.id
      redirect_to cat_url(@cat)
    end
  end
end
