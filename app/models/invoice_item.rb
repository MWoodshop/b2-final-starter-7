class InvoiceItem < ApplicationRecord
  validates_presence_of :invoice_id,
                        :item_id,
                        :quantity,
                        :unit_price,
                        :status

  belongs_to :invoice
  belongs_to :item

  enum status: %i[pending packaged shipped]

  def self.incomplete_invoices
    invoice_ids = InvoiceItem.where('status = 0 OR status = 1').pluck(:invoice_id)
    Invoice.order(created_at: :asc).find(invoice_ids)
  end

  def unit_price_in_dollars
    unit_price / 100.0
  end

  def total_before_discounts
    unit_price * quantity / 100
  end

  def total_after_discounts
    revenue / 100.0
  end

  def applicable_discount
    item.merchant.discounts
        .where('quantity_threshold <= ?', quantity)
        .order(percentage_discount: :desc)
        .first
  end

  def discounted_unit_price
    if discount = applicable_discount
      unit_price - (unit_price * discount.percentage_discount / 100.0)
    else
      unit_price
    end
  end

  def revenue
    quantity * discounted_unit_price
  end
end
