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
    user = User.new(name: nil,email:nil,permalink:nil,password:nil)
    refute user.valid?
    [:name,:email,:permalink,:password].each do |field|
      refute_empty user.errors[field] end
  end

  test "name must not be empty" do
    @user.name = nil
    refute @user.valid?, 'Saved user without a name'
    refute_empty @user.errors[:name]
  end

  test "permalink must not be empty" do
    @user.permalink = nil
    refute @user.valid?, 'Saved user without a permalink'
    refute_empty @user.errors[:permalink]
  end

  test "email must not be empty" do
    @user.email = nil
    refute @user.valid?, 'Saved user without an email'
    refute_empty @user.errors[:email]
  end

  test "password must not be empty" do
    user = User.create(name: 'Dummydummy', password:nil, password_confirmation: "Dummydummy", email: "Dummydummy@example.com", permalink: "qwerty")
    refute_empty user.errors[:password]
  end

  test "password and password_confirmation must match when create user" do
    # assert wrong password confirmation
    user = User.create(name: 'samiam', password: "hoohaahh", password_confirmation: "hooooooo", email: "m@example.com", permalink: "qwerty")
    refute_empty user.errors[:password_confirmation]

    # assert correct password confirmation
    user.password_confirmation = "hoohaahh"
    assert user.valid?
    assert_empty user.errors[:password_confirmation]
  end

  test "password and password_confirmation must match when update user" do
    # assert password confirmation when update user
    user = User.create(name: 'samiam', password: "hoohaahh", password_confirmation: "hoohaahh", email: "m@example.com", permalink: "qwerty")
    user.password = "anotherpass"
    refute user.valid?
    assert user.errors[:password_confirmation].any?, "password_confirmation matches password"
  end

  test "password should be at least 8 char" do #this probably doesn't need to be tested because this is a function of Devise
    @user.password = "hihihi"
    @user.password_confirmation = "hihihi"
    assert @user.invalid?, "password needs to be at least 8 char" #needed here - perhaps when using @user created in setup?
    refute_empty @user.errors[:password]
  end

  #validates :email, presence: true, uniqueness: { case_sensitive: false }
  test "email of new user should be unique" do
    user1 = User.create(name: 'samiam', password: "hoohaahh", password_confirmation: "hoohaahh",
                        email: "mo@example.com", permalink: "qwerty")
    user2 = User.create(name: 'samiam', password: "hoohaahh", password_confirmation: "hoohaahh",
                        email: "mo@example.com", permalink: "qwat")
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
    @user.permalink = "example.com/c.php?g=724398&p=5173143!"
    refute @user.valid?, "permalink alphanumeric"
    refute_empty @user.errors[:permalink]
  end

  # validates:length: { maximum: 20 }
  test "permalink should be under 20 chars" do
    #assert permalink over 20 chars
    @user.permalink = "b" * 25
    refute @user.valid?, "Permalink is over 20 characters"
    refute_empty @user.errors[:permalink]

    #assert permalink at the limit
    @user.permalink = "b" * 20
    assert @user.valid?, "Permalink at the limit should be valid"
    assert_empty @user.errors[:permalink]
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

  #before_save { |user| user.permalink = permalink.downcase }

  test "make all permalinks lowercase" do
    user = User.new(name: 'Dummydummy', password:'Dummydummy', password_confirmation: 'Dummydummy', email: "Dummydummy@example.com", permalink: "ExAmplELink")
    user.save
    assert_equal 'examplelink', user.permalink
  end

  #before_save { |user| user.email = email.downcase }

  test "make all emails lowercase" do
    user = User.new(name: 'Dummydummy', password:'Dummydummy', password_confirmation: 'Dummydummy', email: "DUMMYDummy@ExAmplE.Com", permalink: "qwerty")
    user.save
    assert_equal 'dummydummy@example.com', user.email
  end

  test "name must be less than 50" do
    user = User.new( name: @name_over.call(55),email:"email@email.com",permalink:"permalink",password:"password")
    refute user.valid?
    assert_equal ["is too long (maximum is 50 characters)"], user.errors[:name]

    #assert name at the limit
    user.name = @name_over.call(50)
    assert user.valid?, "Name at the limit should be valid"
    assert_empty user.errors[:name]
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
    user.password_confirmation = user.password
    assert user.password_changed?
  end

  test "following?_test" do
    user_a =users(:one)
    user_b =users(:two)
    refute user_a.following?(user_b)
  end

   # after_initialize :assign_defaults_on_new_user, if: -> {new_record?}
  test "default values are assigned to user" do
    user = User.create(name: 'Dummydummy', password:'Dummydummy', password_confirmation: "Dummydummy", email: "Dummydummy@example.com", permalink: "qwerty")
    assert_equal 'storyteller', user.author

    user = users(:one)
    assert_equal 'author', user.author
  end

  test "calc test" do
    assert_nil @user.totalinfo
    @user.calcdashboard
    [:soldtitle,:soldprice,:authorcut,:purchaseid,:soldwhen,:whobought,:address,:fulfilstat,:egoods].each do |field|
      refute_empty(field)
      refute_nil @user.totalinfo
    end
  end

   test "user retrieved from database if auth existed" do
    auth = OmniAuth::AuthHash.new({provider: "facebook", uid: "98765", info: {name:"HieuPhung", email:"example@mail.com"}})
    # assert no changes in database
    assert_no_difference('User.count') do
      User.from_omniauth(auth)
    end

    # assert user retrieved from database
    User.from_omniauth(auth)
    user = User.find_by uid: "98765"
    assert_equal user.name, "userconfirmed"
    assert_equal user.email, "thinqtesting@gmail.com"
  end

  test "user created if auth did not exist" do
    auth = OmniAuth::AuthHash.new({provider: "facebook", uid: "12345", info: {name:"Reagan", email:"awesome96@email.com", permalink:"reagan12", password:"awesomepass", image:'nicejpg'} })
    # assert changes in database
    assert_difference('User.count', 1) do
      user = User.from_omniauth(auth)  
    end

    # assert user created in database
    User.from_omniauth(auth)
    user = User.find_by name:"Reagan"
    assert_equal user.provider, "facebook"
    assert_equal user.uid, "12345"
    assert_equal user.email, "awesome96@email.com"
    # assert_equal user.profilepic, 'nicejpg' Cant test this now because a real image needs to be uploaded
  end

  test "users are returned in descending order" do
    expected = {"order"=>"DESC"}
  	assert_equal  expected, User.updated_at.where_values_hash
  end

end
