class DiscountsController < ApplicationController
  before_action :set_merchant
  before_action :set_discount, only: %i[show destroy]

  def index
    @merchant = Merchant.find(params[:merchant_id])

    @discounts = @merchant.discounts
  end

  def new
    @discount = @merchant.discounts.new
  end

  def create
    @discount = @merchant.discounts.new(discount_params)
    if @discount.save
      redirect_to merchant_discounts_path(@merchant), notice: 'Discount was successfully created.'
    else
      flash.now[:error] = @discount.errors.full_messages.to_sentence
      render :new
    end
  end

  def show; end

  def edit
    @discount = @merchant.discounts.find(params[:id])
  end

  def update
    @discount = @merchant.discounts.find(params[:id])
    if @discount.update(discount_params)
      redirect_to merchant_discount_path(@merchant, @discount), notice: 'Discount was successfully updated.'
    else
      flash.now[:error] = @discount.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    @discount = @merchant.discounts.find(params[:id])
    @discount.destroy
    redirect_to merchant_discounts_path(@merchant), notice: 'Discount was successfully deleted.'
  end

  private

  def discount_params
    params.require(:discount).permit(:name, :percentage_discount, :quantity_threshold)
  end

  def set_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

  def set_discount
    @discount = @merchant.discounts.find(params[:id])
  end
end
