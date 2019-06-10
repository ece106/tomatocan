require 'test_helper'

class TestUser < ActiveSupport::TestCase
  def setup
#    @request.env['devise.mapping'] = Devise.mappings[:user]
    @user = users(:one)
    @rand_Az = lambda{|len|name=Array('A'.."z");Array.new(len){name.sample}.join}
    @name_over = lambda {|len| name = Array('A'..'Z')+Array('a'..'z');Array.new(len) {name.sample}.join}

#sign_in @user  #why dont I need this for model
  end
  test "user_can_follow_another_user" do
    john = users(:one)
    mark = users(:two)
    assert_not john.following?(mark)
    john.follow(mark)
    assert john.following?(mark)
  end

  test "user can unfollow another user" do
    john = users(:one)
    mark = users(:two)
    john.follow(mark)
    assert john.following?(mark)
    john.unfollow(mark)
    assert_not john.following?(mark)
  end

  test "userfields_must_not_be_empty" do
    user = User.new(name: nil,email:nil,permalink:nil,password:nil )
    refute user.valid?
    [:name,:email,:permalink,:password].each do |field|
      refute_empty user.errors[field] end
  end

  test "password and password_confirmation must match" do
    user = User.create(name: 'samiam', password: "hoohaahh", password_confirmation: "hooooooo", email: "m@example.com", permalink: "qwerty")
    assert user.errors[:password_confirmation].any?, "password_confirmation matches password"
  end

  test "password should be at least 8 char" do #this probably doesn't need to be tested because this is a function of Devise
    @user.password = "hihihi"
    @user.password_confirmation = "hihihi"
    assert @user.invalid?, "password needs to be at least 8 char" #needed here - perhaps when using @user created in setup?
    refute_empty @user.errors[:password]
  end

  test "password can be empty and password_confirmation doesnt matter" do
    @user.password = nil
    @user.password_confirmation = "hihihi"
    assert_empty @user.errors[:password]
  end

  #validates :email, presence: true, uniqueness: { case_sensitive: false }
  test "email of new user should be unique" do
    user1 = User.create(name: 'samiam', password: "hoohaahh", password_confirmation: "hoohaahh",
                        email: "mo@example.com", permalink: "qwerty")
    user2 = User.create(name: 'samiam', password: "hoohaahh", password_confirmation: "hoohaahh",
                        email: "mo@example.com", permalink: "qwat")
    refute_empty user2.errors[:email] #refute user2.valid not needed for this
    assert user2.errors[:email].any?, "email unique" # refute user.valid not needed for .any
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

  test "videodesc_must_be_less_than255char" do
    [:videodesc1, :videodesc2, :videodesc3 ].each do |field|
      user = User.new("#{field}": @rand_Az.call(266))
      refute user.valid?
      assert_equal ["is too long (maximum is 255 characters)"], user.errors[field]
    end
  end

  #validates :permalink, format: { with: /\A[\w+]+\z/ }

  test "make all permalinks lowercase" do
    @user.permalink = "LisaLisa"
    @user.save
    assert_match(/[a-z0-9]/, @user.permalink)
  end

  #before_save { |user| user.email = email.downcase }

  test "make all emails lowercase" do
    @user.email = "you@CrowdPublish.TV"
    @user.save
    assert_match(/[a-z0-9]+@+[a-z0-9]+\.+[a-z]/, @user.email)
  end

  test "parse youtube" do
    @user.youtube1 = "http://youtube.com/watch?v=/frlviTJc"
    @user.genre1 = "yaaah"
    @user.permalink = "LisaLisa"
    @user.get_youtube_id
    refute_equal("http://youtube.com/watch?v=/frlviTJc", @user.youtube1)  #why refute?
  end

  test "get_youtube_id_test" do
    target = "/id12345"
    compare = "http://youtube.com/watch?v="+ target
    @user.youtube1 = compare
    @user.youtube2 = compare
    @user.youtube3 = compare
    @user.get_youtube_id
    assert_equal target, @user.youtube1
    assert_equal target, @user.youtube2
    assert_equal target, @user.youtube3
  end

  test "calc test" do
    assert_nil @user.totalinfo
    @user.calcdashboard
    [:soldtitle,:soldprice,:authorcut,:purchaseid,:soldwhen,:whobought,:address,:fulfilstat,:egoods].each do |field|
      refute_empty(field)
      refute_nil @user.totalinfo
    end
  end

  test "user must have a password" do
    user_no_password = User.new(name: nil,email:nil,permalink:nil,)
    refute user_no_password.valid?
  end
  test "name must be less than 50" do
    user = User.new( name: @name_over.call(55),email:"email@email.com",permalink:"permalink",password:"password")
    refute user.valid?
    assert_equal ["is too long (maximum is 50 characters)"], user.errors[:name]
  end
  test "mark_fulfilled_test" do
    purchase = purchases(:one)
    @user.mark_fulfilled(purchase.id)
    x = Purchase.find(purchase.id)
    assert_equal "sent", x.fulfillstatus
  end

  test "validates_twitter_test" do
    user = User.new(twitter:"!@@@#%@#")
    assert user.errors.messages[:twitter]
  end

  test "password_change_test" do
    password = SecureRandom.alphanumeric(8)
    new_password = SecureRandom.alphanumeric(8)
    user = User.new(password:password)
    user.password = new_password
    assert user.password_changed?
  end

  test "following?_test" do
    user_a =users(:one)
    user_b =users(:two)
    refute user_a.following?(user_b)
  end

  # redundant tests

  test "redundant_test_name_and_permalink_must_not_be_empty" do
    user = User.create(password: "hoohaahh", password_confirmation: "hoohaahh", email: "m@example.com")
    refute_empty user.errors[:name]
    refute_empty user.errors[:permalink]
  end

  test "redundant_test_new_user_must_have_reqd_variables" do
    user = User.new
    user.permalink = "Dummydummy"
    user.name = "Dummydummy"
    user.email = "ee@ujk.com"
    user.password = "Dummydummy"
    user.password_confirmation = "Dummydummy"
#    refute user.valid? # email errors are empty if email is bad and this line not here
    assert_empty user.errors[:email]
  end

  test "redundant_test_create_user_must_have_reqd_variables" do
    user = User.create(name: 'samiam', password: "hoohaahh", password_confirmation: "hoohaahh", email: "unique@example.com", permalink: "qwerty")
    assert_empty user.errors[:email]
#    refute user.errors[:email].any?, "email unique"
#    assert user.errors.any?
  end

  test "redundant_test_email_still_must_not_be_empty" do
    @user.send "email=", nil
    refute @user.valid?
    refute_empty @user.errors[:email]
  end

  test "edit_user_password" do
    user = users(:one)
  end

end
