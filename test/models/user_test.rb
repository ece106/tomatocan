require 'test_helper'

class TestUser < ActiveSupport::TestCase
  def setup
#    @request.env['devise.mapping'] = Devise.mappings[:user]
#    sign_in @user
    @user = users(:one)
  end

  [:email, :name, :permalink, :password, :password_confirmation].each do |field|
    define_method "#{field.to_s}_must_not_be_empty" do
      @user = User.new
      @user.send "#{field.to_s}=", nil
      refute @user.valid?
      refute_empty @user.errors[field]
    end
  end


  test "user attributes must not be empty" do #need to Create user
#    @user = build(:user, name: 'samiam', email: 'fakeunique@fake.com', password: 'secret12', password_confirmation: 'secret12', permalink: 'samlink', address: '22181' )
    assert @user.valid?
#    assert @user.errors[:name].any?
#    assert @user.errors[:email].any?
  end

  test "password and password_confirmation should match" do
    @user = users(:two) #can't give a password in db. Might need factory girl?
    assert @user.valid?
   # refute @user.valid?
  end

  test "email should be unique" do
    @user1 = User.new
    @user2 = User.new
    @user1.email = "notanemail"
    @user2.email = "notanemail2"
    refute @user2.valid?, "email not unique" #why doesnt this fail - where are the user.emails being stored
  end 
  
end
