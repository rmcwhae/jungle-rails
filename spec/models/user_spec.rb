# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validations' do
    it 'User can be created with first name, last name, password, password confirmation, and email' do
      @user = User.new(first_name: 'Harry', last_name: 'Potter', password: 'test', password_confirmation: 'test', email: 'test@test.com')
      expect(@user).to be_valid
    end

    it 'Password and password confirmation must match' do
      @user = User.new(first_name: 'Harry', last_name: 'Potter', password: 'test', password_confirmation: 'stuff', email: 'test@test.com')
      expect(@user).to_not be_valid
      expect(@user.errors.full_messages.first).to eq "Password confirmation doesn't match Password"
    end

    it 'Email must be unique' do
      @user1 = User.create(first_name: 'Harry', last_name: 'Potter', password: 'test', password_confirmation: 'test', email: 'test@test.com')
      @user2 = User.new(first_name: 'Ron', last_name: 'Weasley', password: 'stuff', password_confirmation: 'stuff', email: 'TEST@TEST.com')
      expect(@user2).to_not be_valid
    end

    it 'Email, first and last names must be provided' do
      @user = User.new(password: 'test', password_confirmation: 'test')
      expect(@user).to_not be_valid
      expect(@user.errors.full_messages.first).to eq "First name can't be blank"
      expect(@user.errors.full_messages.second).to eq "Last name can't be blank"
      expect(@user.errors.full_messages.third).to eq "Email can't be blank"
    end
  end
end
