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

  [:email, :name, :permalink, :password ].each do |field|
    test "#{field.to_s}_must_not_be_empty" do
      user = User.new
      user.send "#{field.to_s}=", nil
      refute user.valid?
      refute_empty user.errors[field] #must be in same test as above line in order to have usererrors
    end
  end

    test "password_confirmation_must_not_be_empty_when_password_present" do
      user = users(:one) 
      user.update(password: "11111111")
      user.send "password_confirmation=", nil
      refute user.valid?
      refute_empty user.errors[:password_confirmation] 
    end

  test "user attributes must not be empty" do 
    user = User.create(password: "hoohaahh", password_confirmation: "hoohaahh", email: "m@example.com")
#    @user = build(:user, name: 'samiam', email: 'fakeunique@fake.com', password: 'secret12', password_confirmation: 'secret12', permalink: 'samlink', address: '22181' )
      refute user.valid?
#    assert @user.errors.any?
#    assert @user.errors[:name].any?
  end

  test "password and password_confirmation should match" do
    @user = users(:two) 
    @user.password = "hihihihi"
    @user.password_confirmation = "hihihihi"
    assert @user.valid?
  end

  test "password and password_confirmation should be at least 8 char" do
    @user = users(:two) 
    @user.password = "hihihi"
    @user.password_confirmation = "hihihi"
    refute @user.valid?
  end

  test "email of existing user should be unique" do # this doesn't hit db
    user2 = users(:two)
    puts
    puts user2.email 
    puts
    puts user2.name 
    user2.email = "fake@fake.com"
    puts user2.email 
    refute user2.valid?, "email unique"
  end 

  test "email of new user should be unique" do
    user1 = User.create(name: "Dummy1", email: "m@example.com")
    user2 = User.create(name: "Dummy2", email: "m@example.com")
    refute user2.valid?, "email unique"
  end

  test "email should be email" do
    user = users(:one)
    user.email = "email"
    refute user.valid?, "email format valid"
  end 
  
  test "should have format of email address" do
    user = User.create(name: "Dummy", email: "example.com")
    refute_match(/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, user.email)
  end

  test "should have format of email address2" do
    user1 = users(:one)
    user1.email = "email@lisa.org"
    assert_match(/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, user1.email)
    user2 = users(:one)
    user2.email = "email"
    refute_match(/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, user2.email)
  end
end
