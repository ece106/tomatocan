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
    user.send "#{field.to_s}=", nil
    refute user.valid?
    refute_empty user.errors[field] 
  end
end

  test "password_confirmation_must_not_be_empty_when_password_present" do
    @user.update(password: "garblygook") #is this testing the model or is it integration testing
    @user.send "password_confirmation=", nil
#    puts "in password_confirmation_must_not_be_empty_when_password_present, password = " + @user.password
#    puts "in password_confirmation_must_not_be_empty_when_password_present, password_confirmation = " + @user.password_confirmation.to_s
    refute_empty @user.errors[:password_confirmation] 
  end

  test "password_and_password_confirmation_must_match" do
    user = User.create(name: 'samiam', password: "hoohaahh", password_confirmation: "hooooooo", email: "m@example.com", permalink: "qwerty")
    assert user.errors[:password_confirmation].any?, "password_confirmation matches password"
  end

  test "password must be at least 8 char" do
      @user.password = "1234567"
      @user.password_confirmation = "1234567"
      assert @user.invalid?, "password is at least 8 char"
      refute_empty @user.errors[:password] 
      puts "password errors " + @user.errors[:password].to_s
  end

  test "password can be empty and password_confirmation doesnt matter" do
    @user.password = nil
    @user.password_confirmation = "hihihi"
    assert_empty @user.errors[:password] 
  end

#validates :email, presence: true, uniqueness: { case_sensitive: false }
  test "email of new user should be unique" do
    user1 = User.create(name: 'samiam', password: "hoohaahh", password_confirmation: "hoohaahh", 
                        email: "mo@CrowdPublish.TV", permalink: "lisa")
    user2 = User.create(name: 'samiam', password: "hoohaahh", password_confirmation: "hoohaahh", 
                        email: "mo@CrowdPublish.TV", permalink: "CrowdPublishTV")
    refute_empty user2.errors[:email]
    assert user2.errors[:email].any?, "email unique" 
  end

#validates :permalink, uniqueness: { case_sensitive: false }
  test "permalink must be unique" do
    @user.permalink = "MyPermalink"
    @user.save
    user2 = users(:two)
    user2.permalink = "mypermaLink"
    refute user2.valid?, "permalink unique" 
    refute_empty user2.errors[:permalink] 
  end 

#validates :permalink, format:     { with: /\A[\w+]+\z/ }
  test "permalink must be alphanumeric" do
    @user.permalink = "whatthe@#$%&!"
    refute @user.valid?, "permalink alphanumeric" 
    refute_empty @user.errors[:permalink] 
  end 

#  validates_format_of   :email, :with  => Devise.email_regexp, 
  test "should have format of email address" do
    @user.email = "email@lisa.org"
    assert @user.valid?, "wrong email format" 
    assert_empty @user.errors[:email] 
    user2 = users(:two)
    user2.email = "email"
    refute user2.valid?, "proper email format" 
    refute_empty user2.errors[:email] 
  end

#validates :videodesc1, length: { maximum: 255 }
  [:videodesc1, :videodesc2, :videodesc3 ].each do |field|
    test "#{field.to_s}_must_be_less_than255char" do
      @user.send "#{field.to_s}=", "supercalifragilisticexpialidocioussupercalifragilisticexpialidocioussupercalifragilisticexpialidocioussupercalifragilisticexpialidocioussupercalifragilisticexpialidocioussupercalifragilisticexpialidocioussupercalifragilisticexpialidocioussupercalifragilisticexpialidocioussupercalifragilisticexpialidocioussupercalifragilisticexpialidocioussupercalifragilisticexpialidocious"
      refute @user.valid?, "video description is short enough" 
      refute_empty @user.errors[field] 
    end
  end

#validates :permalink, format: { with: /\A[\w+]+\z/ }

  test "make all permalinks lowercase" do
    @user.permalink = "LisaLisa"
    @user.save
    puts @user.permalink
    assert_match(/[a-z0-9]/, @user.permalink)
  end

#before_save { |user| user.email = email.downcase }

  test "make all emails lowercase" do
    @user.email = "you@CrowdPublish.TV"
    @user.save
    assert_match(/[a-z0-9]+@+[a-z0-9]+\.+[a-z]/, @user.email)
  end

#def add_bank_account

  test "add bank account" do #this test only works for new account or account with countryoftax=GB
    # should test the view to make sure users can't enter currency/countryofbank incompatible with countryoftax
    # having specific acct_number in fixture is bad way to test. Figure out a way to test using a relevant acct
    @user.add_bank_account('GBP', '000123456789', '110000000', 'WX', 'address line1',
                        'address line2', 'city ilivein', '11111', 'AZ')
    assert @user.valid?, "cant have that currency in that country" #useless. This cant make a user invalid. proves nothing
    assert_match(@user.countryofbank, 'GB') 
    # what i want is to test that the private attributes are getting changed
    # Although I'm still questioning whether I want the method to do that. Perhaps it should alert the user that 
    # the countryofbank/currency/countryoftax combo is invalid (on next page? JS?) and prompt user to correct the mistake
  end

  test "stripe accounts" do
#    Retrieve accounts object and make sure correct info there
  end

  test "external accounts" do
#    Retrieve external_accounts object and make sure correct info there
  end

# this is testing the feature, not the private method - It works on localhost, why isn't it happening in test
  test "parse ustream" do
    @user.ustreamvid = "http://www.ustream.tv/embed/21534532?html5ui style=border: 0 none transparent;  webkitallowfullscreen allowfullscreen frameborder=></iframe><br /><a href=http://www.ustream.tv/ style=adding: 2px 0px 4px; width: 400px; background: #ffffff; display: block; color: #000000; font-we"
    ustreamtemp = @user.ustreamvid
    @user.save
    refute_equal(ustreamtemp, @user.ustreamvid)
  end

  test "parse youtube" do
    @user.youtube1 = "http://youtube.com/watch?v=/diff"
    @user.genre1 = "yaaah"
    @user.permalink = "LisaLisa"
    puts @user.permalink
    @user.save
    puts @user.permalink
    puts "lllllllllllllllllllllllllllllllllllllf"
    puts @user.genre1
    puts @user.youtube1
    refute_equal("http://youtube.com/watch?v=/frlviTJc", @user.youtube1)
  end


end

