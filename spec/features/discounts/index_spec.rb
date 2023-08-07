require 'rails_helper'

RSpec.describe 'discount index' do
  before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')

    @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
    @customer_2 = Customer.create!(first_name: 'Cecilia', last_name: 'Jones')
    @customer_3 = Customer.create!(first_name: 'Mariah', last_name: 'Carrey')
    @customer_4 = Customer.create!(first_name: 'Leigh Ann', last_name: 'Bron')
    @customer_5 = Customer.create!(first_name: 'Sylvester', last_name: 'Nader')
    @customer_6 = Customer.create!(first_name: 'Herber', last_name: 'Kuhn')

    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2)
    @invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 2)
    @invoice_5 = Invoice.create!(customer_id: @customer_4.id, status: 2)
    @invoice_6 = Invoice.create!(customer_id: @customer_5.id, status: 2)
    @invoice_7 = Invoice.create!(customer_id: @customer_6.id, status: 1)

    @item_1 = Item.create!(name: 'Shampoo', description: 'This washes your hair', unit_price: 10,
                           merchant_id: @merchant1.id)
    @item_2 = Item.create!(name: 'Conditioner', description: 'This makes your hair shiny', unit_price: 8,
                           merchant_id: @merchant1.id)
    @item_3 = Item.create!(name: 'Brush', description: 'This takes out tangles', unit_price: 5,
                           merchant_id: @merchant1.id)
    @item_4 = Item.create!(name: 'Hair tie', description: 'This holds up your hair', unit_price: 1,
                           merchant_id: @merchant1.id)

    @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 1, unit_price: 10,
                                status: 0)
    @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 1, unit_price: 8, status: 0)
    @ii_3 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 2)
    @ii_4 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_5 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_6 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_7 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)

    @transaction1 = Transaction.create!(credit_card_number: 203_942, result: 1, invoice_id: @invoice_1.id)
    @transaction2 = Transaction.create!(credit_card_number: 230_948, result: 1, invoice_id: @invoice_3.id)
    @transaction3 = Transaction.create!(credit_card_number: 234_092, result: 1, invoice_id: @invoice_4.id)
    @transaction4 = Transaction.create!(credit_card_number: 230_429, result: 1, invoice_id: @invoice_5.id)
    @transaction5 = Transaction.create!(credit_card_number: 102_938, result: 1, invoice_id: @invoice_6.id)
    @transaction6 = Transaction.create!(credit_card_number: 879_799, result: 1, invoice_id: @invoice_7.id)
    @transaction7 = Transaction.create!(credit_card_number: 203_942, result: 1, invoice_id: @invoice_2.id)

    @discount_1 = @merchant1.discounts.create!(percentage_discount: 5, quantity_threshold: 20)
  end

  # User Story 1
  # Merchant Bulk Discounts Index

  # As a merchant
  # When I visit my merchant dashboard
  # Then I see a link to view all my discounts
  # When I click this link
  # Then I am taken to my bulk discounts index page
  # Where I see all of my bulk discounts including their
  # percentage discount and quantity thresholds
  # And each bulk discount listed includes a link to its show page

  it 'shows all discounts with a link to the discount show page' do
    visit merchant_discounts_path(@merchant1)
    expect(current_path).to eq(merchant_discounts_path(@merchant1))
    within("#discount-#{@discount_1.id}") do
      expect(page).to have_content(@discount_1.id.to_s)
      expect(page).to have_content(@discount_1.percentage_discount.to_s)
      expect(page).to have_content(@discount_1.quantity_threshold.to_s)
      expect(page).to have_link(@discount_1.id.to_s, href: merchant_discount_path(@merchant1, @discount_1))
    end
  end

  # User Story 2:
  # Merchant Bulk Discount Create

  # As a merchant
  # When I visit my bulk discounts index
  # Then I see a link to create a new discount
  # When I click this link
  # Then I am taken to a new page where I see a form to add a new bulk discount
  # When I fill in the form with valid data
  # Then I am redirected back to the bulk discount index
  # And I see my new bulk discount listed

  it 'allows me to create a new discount - happy path' do
    visit merchant_discounts_path(@merchant1)
    expect(current_path).to eq(merchant_discounts_path(@merchant1))
    expect(page).to have_link('Create New Discount', href: new_merchant_discount_path(@merchant1))
    click_link 'Create New Discount'

    expect(current_path).to eq(new_merchant_discount_path(@merchant1))
    expect(page).to have_selector('form')
    fill_in 'discount[percentage_discount]', with: 90
    fill_in 'discount[quantity_threshold]', with: 9
    click_button 'Submit'
    expect(current_path).to eq(merchant_discounts_path(@merchant1))
    expect(page).to have_content('Discount was successfully created.')
    within('table.show-table tr:last-child') do
      expect(page).to have_content('90')
      expect(page).to have_content('9')
    end
  end

  it 'allows me to create a new discount - sad path' do
    visit merchant_discounts_path(@merchant1)
    expect(current_path).to eq(merchant_discounts_path(@merchant1))
    expect(page).to have_link('Create New Discount', href: new_merchant_discount_path(@merchant1))
    click_link 'Create New Discount'

    expect(current_path).to eq(new_merchant_discount_path(@merchant1))
    expect(page).to have_selector('form')
    click_button 'Submit'
    expect(page).to have_content("Percentage discount can't be blank")
    fill_in 'discount[percentage_discount]', with: 'aaa'
    fill_in 'discount[quantity_threshold]', with: 'bbb'
    expect(page).to have_content('Percentage discount is not a number')
    expect(page).to have_content('Quantity threshold is not a number')
  end

  # User Story 3: Merchant Bulk Discount Delete

  # As a merchant
  # When I visit my bulk discounts index
  # Then next to each bulk discount I see a button to delete it
  # When I click this button
  # Then I am redirected back to the bulk discounts index page
  # And I no longer see the discount listed
  it 'allows me to delete a discount' do
    visit merchant_discounts_path(@merchant1)
    expect(current_path).to eq(merchant_discounts_path(@merchant1))
    click_link 'Create New Discount'

    fill_in 'discount[percentage_discount]', with: 90
    fill_in 'discount[quantity_threshold]', with: 9
    click_button 'Submit'
    expect(current_path).to eq(merchant_discounts_path(@merchant1))
    within('table.show-table tr:last-child') do
      expect(page).to have_button('Delete')
      click_button 'Delete'
    end
    expect(current_path).to eq(merchant_discounts_path(@merchant1))
    expect(page).to have_content('Discount was successfully deleted.')
  end
end
