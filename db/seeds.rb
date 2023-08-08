# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
InvoiceItem.destroy_all
Item.destroy_all
Invoice.destroy_all
Discount.destroy_all
Customer.destroy_all
Merchant.destroy_all

Rake::Task['csv_load:all'].invoke

# Creating Merchants
merchant_a = Merchant.create!(name: 'Merchant A')
merchant_b = Merchant.create!(name: 'Merchant B')

# Customers
customer = Customer.create!(first_name: 'John', last_name: 'Doe', address: '123 Main St', city: 'Anytown', state: 'CA',
                            zip: 12_345)

# Discounts for Merchant A
discount_a1 = merchant_a.discounts.create!(percentage_discount: 20, quantity_threshold: 10)
discount_a2 = merchant_a.discounts.create!(percentage_discount: 30, quantity_threshold: 15)
discount_a3 = merchant_a.discounts.create!(percentage_discount: 15, quantity_threshold: 15)

# Items for Merchant A & Merchant B
item_a1 = merchant_a.items.create!(name: 'Item A1', description: 'Sample', unit_price: 100)
item_a2 = merchant_a.items.create!(name: 'Item A2', description: 'Sample', unit_price: 100)
item_b1 = merchant_b.items.create!(name: 'Item B1', description: 'Sample', unit_price: 100)

# Invoices (associating with the customer)
invoice_1 = customer.invoices.create!(status: 0)
invoice_2 = customer.invoices.create!(status: 0)
invoice_3 = customer.invoices.create!(status: 0)
invoice_4 = customer.invoices.create!(status: 0)
invoice_5 = customer.invoices.create!(status: 0)

# Invoice Items

# Example 1
invoice_1.invoice_items.create!(item: item_a1, quantity: 5, unit_price: item_a1.unit_price, status: 0)
invoice_1.invoice_items.create!(item: item_a2, quantity: 5, unit_price: item_a2.unit_price, status: 0)

# Example 2
invoice_2.invoice_items.create!(item: item_a1, quantity: 10, unit_price: item_a1.unit_price, status: 0)
invoice_2.invoice_items.create!(item: item_a2, quantity: 5, unit_price: item_a2.unit_price, status: 0)

# Example 3
invoice_3.invoice_items.create!(item: item_a1, quantity: 12, unit_price: item_a1.unit_price, status: 0)
invoice_3.invoice_items.create!(item: item_a2, quantity: 15, unit_price: item_a2.unit_price, status: 0)

# Example 4
invoice_4.invoice_items.create!(item: item_a1, quantity: 12, unit_price: item_a1.unit_price, status: 0)
invoice_4.invoice_items.create!(item: item_a2, quantity: 15, unit_price: item_a2.unit_price, status: 0)

# Example 5
invoice_5.invoice_items.create!(item: item_a1, quantity: 12, unit_price: item_a1.unit_price, status: 0)
invoice_5.invoice_items.create!(item: item_a2, quantity: 15, unit_price: item_a2.unit_price, status: 0)
invoice_5.invoice_items.create!(item: item_b1, quantity: 15, unit_price: item_b1.unit_price, status: 0)
