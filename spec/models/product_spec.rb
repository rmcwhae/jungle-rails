# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Product, type: :model do
  before(:each) do
    @category = Category.new
  end

  describe 'Validations' do
    it 'Product can be added with name, price, quantity, and category' do
      @product = Product.new(name: 'Hat', price: 12, quantity: 4, category: @category)
      expect(@category).to be_valid
      expect(@product).to be_valid
    end

    it 'Product is not valid without a price' do
      @product = Product.new(name: 'Hat', price: nil, quantity: 4, category: @category)
      expect(@product).to_not be_valid
      # puts @product.errors.full_messages
      expect(@product.errors.full_messages.first).to eq 'Price cents is not a number'
    end

    it 'is not valid without a quantity' do
      @product = @category.products.new(name: 'Hat', price: 14, quantity: nil)
      expect(@product).to_not be_valid
      expect(@product.errors.full_messages.first).to eq 'Quantity can\'t be blank'
    end
    
    it 'is not valid without a category' do
      @product = Product.new(name: 'Hat', price: 13, quantity: 4, category: nil)
      expect(@product).to_not be_valid
      expect(@product.errors.full_messages.first).to eq 'Category can\'t be blank'
    end
  end
end
