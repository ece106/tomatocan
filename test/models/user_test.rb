require 'test_helper'

class TestUser < ActiveSupport::TestCase
  def setup
#    @request.env['devise.mapping'] = Devise.mappings[:user]
    @user = users(:one)
#    sign_in @user  #why dont I need this for model
  end

  test "after_validation_geocode" do
    oldlatitude = @user.latitude
    @user.address = "20022"
    @user.save
    puts "latitude " + @user.latitude.to_s
    refute_match(@user.latitude, oldlatitude)
  end

  test "after_validation_reverse_geocode" do
    oldaddress = @user.address
    @user.latitude = 20.2
    @user.longitude = 20.2
    @user.save
    puts "new address " + @user.address
    refute_match(@user.address, oldaddress)
  end

  [:email, :name, :permalink, :password ].each do |field|
    test "#{field.to_s}_must_not_be_empty" do
      user = User.new
      user.send "#{field.to_s}=", nil #what does this line do
      refute user.valid?
      refute_empty user.errors[field] #must be in same test as above line in order to have usererrors not be nil
    end
  end

  test "password_confirmation_must_not_be_empty_when_password_present" do
    @user.update(password: "garblygook") #is this testing the model or is it integration testing
    @user.send "password_confirmation=", nil
    refute_empty @user.errors[:password_confirmation] 
  end

  test "name_and_permalink_must_not_be_empty" do 
    user = User.create(password: "hoohaahh", password_confirmation: "hoohaahh", email: "m@example.com")
#    @user = build(:user, name: 'samiam', email: 'fakeunique@fake.com', password: 'secret12', password_confirmation: 'secret12', permalink: 'samlink', address: '22181' )
      #refute user.valid? #but this line isn't needed here
      refute_empty user.errors[:name] 
      refute_empty user.errors[:permalink] 
#    assert @user.errors.any?
#    assert @user.errors[:name].any?
  end

    test "3 password and password_confirmation should match" do
      user = User.create(name: 'samiam', password: "hoohaahh", password_confirmation: "hooooooo", email: "m@example.com", permalink: "qwerty")
      assert user.errors[:password_confirmation].any?, "password_confirmation matches password"
        refute_empty user.errors[:password_confirmation]  #perhaps not needed because paswd_conf not in db
    end

  test "4 password should be at least 8 char" do
    @user.password = "hihihi"
    @user.password_confirmation = "hihihi"
    assert @user.invalid?, "password is at least 8 char" #needed here - perhaps when using @user created in setup?
    refute_empty @user.errors[:password] 
    puts "password errors " + @user.errors[:password].to_s
  end

  test "email of existing user should be unique" do # this doesn't hit db
    @user.email = "MyString2@fake.com"
    refute @user.valid?, "email unique" #not saving to db - needed here
    puts "email unique errors " + @user.errors[:email].to_s
    refute_empty @user.errors[:email] 
  end 

  test "f email of new user should be unique" do
    user1 = User.create(name: 'samiam', password: "hoohaahh", password_confirmation: "hoohaahh", email: "mo@example.com", permalink: "qwerty")
    user2 = User.create(name: 'samiam', password: "hoohaahh", password_confirmation: "hoohaahh", email: "mo@example.com", permalink: "qwat")
      refute_empty user2.errors[:email] #refute user2.valid not needed for this
    assert user2.errors[:email].any?, "email unique" # refute user.valid not needed for .any
  end

  test "g email should be an email address" do
    @user.email = "email.com"
    refute @user.valid?, "email format valid" #needed here
    puts "email format errors " + @user.errors[:email].to_s #why does refute @user.valid have to be before email errors for the errors to print
    refute_empty @user.errors[:email] #why does this count as 2 assertions
  end 
  
  test "h should have format of email address" do
    user = User.create(name: "Dummy", email: "example.com")
    refute_match(/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, user.email)
  end

  test "should have format of email address2" do
    user1 = users(:one)
    user1.email = "email@lisa.org"
    assert_match(/\A[^@]+@([^@\.]+\.)+[^@\.]+\z/, user1.email) #This is supposedly the regex from Devise
    user2 = users(:one)
    user2.email = "email"
    refute_match(/\A[^@]+@([^@\.]+\.)+[^@\.]+\z/, user2.email)
  end

# redundant tests

  test "redundant_test_new_user_must_have_reqd_variables" do
    user = User.new
    user.permalink = "Dummydummy"
    user.name = "Dummydummy"
    user.email = "uio@ujk.com"
    user.password = "Dummydummy"
    user.password_confirmation = "Dummydummy"
    assert user.valid?
    assert_empty user.errors[:email] 
  end

  test "redundant_test_create_user_must_have_reqd_variables" do
    user = User.create(name: 'samiam', password: "hoohaahh", password_confirmation: "hoohaahh", email: "mo@example.com", permalink: "qwerty")
    assert_empty user.errors[:email] 
    assert user.errors[:email].any?, "email unique" 
  end

  test "1what_if_lat_lon_and_address_are_changed" do
    oldaddress = @user.address
    oldlatitude = @user.latitude
    @user.latitude = 20.2
    @user.longitude = 20.2
    @user.address = "20022"
    puts
    puts "latitude " + @user.latitude.to_s
    puts "new address " + @user.address
    @user.save
    puts
    puts "latitude " + @user.latitude.to_s
    puts "new address " + @user.address
    refute_match(@user.address, oldaddress)
  end

  test "email_still_must_not_be_empty" do
    @user.send "email=", nil 
    refute @user.valid?
    refute_empty @user.errors[:email]
  end

end
