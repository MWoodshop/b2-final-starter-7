require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'validations' do
    it { should validate_presence_of :status }
    it { should validate_presence_of :customer_id }
    it { should define_enum_for(:status).with_values(%i[cancelled in_progress completed]) }
  end
  describe 'relationships' do
    it { should belong_to :customer }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many :transactions }
    it { should have_many :invoice_items }
  end

  describe 'instance methods' do
    before(:each) do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @item_1 = Item.create!(name: 'Shampoo', description: 'This washes your hair', unit_price: 1000,
                             merchant_id: @merchant1.id)
      @item_2 = Item.create!(name: 'Conditioner', description: 'This conditions your hair', unit_price: 500,
                             merchant_id: @merchant1.id)
      @discount = @merchant1.discounts.create!(quantity_threshold: 5, percentage_discount: 10)
      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: '2012-03-27 14:54:09')
      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 1000,
                                  status: 2)
      @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 1, unit_price: 500,
                                  status: 1)
    end

    it '#total_revenue' do
      # 9 items of $10 each + 1 item of $5 = $95 or 9500 cents
      expect(@invoice_1.total_revenue).to eq(9500)
    end

    it '#total_discounted_revenue' do
      # 10% discount for 9 items of Shampoo: (9 items * $9 each) + 1 item of $5 = $86 or 8600 cents
      expect(@invoice_1.total_discounted_revenue).to eq(8600)
    end

    it '#total_revenue_in_dollars' do
      expect(@invoice_1.total_revenue_in_dollars).to eq(95.00)
    end

    it '#total_discounted_revenue_in_dollars' do
      expect(@invoice_1.total_discounted_revenue_in_dollars).to eq(86.00)
    end
  end
end
