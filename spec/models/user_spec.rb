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
      expect(@user2.errors.full_messages.first).to eq 'Email has already been taken'
    end

    it 'Email, first and last names must be provided' do
      @user = User.new(password: 'test', password_confirmation: 'test')
      expect(@user).to_not be_valid
      expect(@user.errors.full_messages.first).to eq "First name can't be blank"
      expect(@user.errors.full_messages.second).to eq "Last name can't be blank"
      expect(@user.errors.full_messages.third).to eq "Email can't be blank"
    end

    it 'Password must be at least 4 characters' do
      @user = User.new(first_name: 'Ron', last_name: 'Weasley', password: '123', password_confirmation: '123', email: 'TEST@TEST.com')
      expect(@user).to_not be_valid
      expect(@user.errors.full_messages.first).to eq 'Password is too short (minimum is 4 characters)'
    end
  end

  describe '.authenticate_with_credentials' do
    before do
      @user = User.create(first_name: 'Harry', last_name: 'Potter', password: 'test', password_confirmation: 'test', email: 'test@test.com')
      expect(@user).to be_valid
    end

    it 'Logs in with correct info' do
      @login_attempt = User.authenticate_with_credentials('test@test.com', 'test')
      expect(@login_attempt.first_name).to eq 'Harry'
      expect(@login_attempt.last_name).to eq 'Potter'
    end

    it 'Logs in with correct info, including spaces in email' do
      @login_attempt = User.authenticate_with_credentials('   test@test.com ', 'test')
      expect(@login_attempt.first_name).to eq 'Harry'
      expect(@login_attempt.last_name).to eq 'Potter'
    end

    it 'Logs in with correct info, including wrong letter case in email' do
      @login_attempt = User.authenticate_with_credentials('TEST@teST.coM', 'test')
      expect(@login_attempt.first_name).to eq 'Harry'
      expect(@login_attempt.last_name).to eq 'Potter'
    end

    it 'Fails to login with incorrect password' do
      @login_attempt = User.authenticate_with_credentials('test@test.com', 'test2')
      expect(@login_attempt).to be_nil
    end

    it 'Fails to login with nil password' do
      @login_attempt = User.authenticate_with_credentials('test@test.com', nil)
      expect(@login_attempt).to be_nil
    end

    it 'Fails to login with incorrect email address' do
      @login_attempt = User.authenticate_with_credentials('test2@test.com', 'test')
      expect(@login_attempt).to be_nil
    end

    it 'Fails to login with nil email address' do
      @login_attempt = User.authenticate_with_credentials(nil, 'test')
      expect(@login_attempt).to be_nil
    end

  end
end
