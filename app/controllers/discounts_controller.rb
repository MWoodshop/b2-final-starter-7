class DiscountsController < ApplicationController
  before_action :set_merchant
  before_action :set_discount, only: [:show]

  def index
    @merchant = Merchant.find(params[:merchant_id])
    @discounts = @merchant.discounts
  end

  private

  def set_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

  def set_discount
    @discount = @merchant.discounts.find(params[:id])
  end
end
