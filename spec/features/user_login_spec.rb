# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Visitor orders a product', type: :feature, js: true do
  before :each do
    @user = User.create!(
      first_name: 'First',
      last_name: 'Last',
      email: 'first@user.com',
      password: '123456',
      password_confirmation: '123456'
    )

    @category = Category.create! name: 'Apparel'
    @category.products.create!(
      name: 'Cool Shirt',
      description: 'A really cool shirt.',
      image: 'test.jpg',
      quantity: 3,
      price: 12.99
    )
  end

  scenario 'They complete an order while logged in' do
    visit '/login'

    within 'form' do
      fill_in id: 'email', with: 'first@user.com'
      fill_in id: 'password', with: '123456'

      click_button 'Submit'
    end

    expect(page).to have_content 'Signed in as first@user.com'
  end
end
