# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Rake::Task['csv_load:all'].invoke
merchant_1 = Merchant.create!(name: 'Always Going Out of Business', status: 1)
merchant_2 = Merchant.create!(name: 'Grand Reopening All The Time', status: 1)

merchant_1.discounts.create!(
  percentage_discount: 50,
  quantity_threshold: 5
)

merchant_1.discounts.create!(
  percentage_discount: 10,
  quantity_threshold: 1
)

merchant_2.discounts.create!(
  percentage_discount: 75,
  quantity_threshold: 10
)

merchant_2.discounts.create!(
  percentage_discount: 10,
  quantity_threshold: 2
)
