class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  enum status: %i[cancelled in_progress completed]

  def total_revenue
    invoice_items.sum('unit_price * quantity')
  end

  def total_discounted_revenue
    invoice_items.sum(&:revenue)
  end

  def total_revenue_in_dollars
    total_revenue / 100.0
  end

  def total_discounted_revenue_in_dollars
    total_discounted_revenue / 100.0
  end
end
