require 'test_helper'

class MerchandiseTest < ActiveSupport::TestCase

  def setup
    @merchandise = merchandises(:one)
    @all_merchandises = merchandises.each  { |x| @all_merchandises = x } 
    @merchandise_attachments = [:merchpdf,:merchmobi,:graphic,:video,:merchepub,:audio]
  end

  test 'merchandise_with_attachments not empty' do
    merchandise_with_attachments = @all_merchandises.each { |x| @merchandise_attachments.each { |p| x[p] } }
    @merchandise_attachments.each do |x|
      refute_empty merchandise_with_attachments.each { |p| p[x] } 
    end
  end
   
  test "price should not be empty" do
    @merchandise.price = nil
    refute @merchandise.valid?
    #refute_empty @merchandise.errors[:price]
  end

  test "name should not be empty" do
    @merchandise.name = nil
    refute @merchandise.valid?, 'saved merchandise without a name'
    #assert_not_nil @merchandise.errors[:name], 'no validation for presence of name'
  end

  test "error message for name presence" do
    @merchandise.name = nil

    assert_not @merchandise.save, 'no validation for presence of name'
  end

  test "buttontype should not be empty" do
    @merchandise.buttontype = nil
    refute @merchandise.valid?, 'saved merchandise without a buttontype'
    assert_not_nil @merchandise.errors[:buttontype], 'no validation for presence of buttontype'
  end

  test "buttontype should only be Buy or Donate" do
    @merchandise.buttontype = "string"
    refute @merchandise.valid?, 'saved an invalid value for buttontype'
  end

  test "price should be numerical" do
    @merchandise.price = "string"
    refute @merchandise.valid?, 'saved merchandise with a non numerical price'
  end

  test "user association" do
    refute defined?(@merchandise.user) == nil, 'saved merchandise with no user'
  end

  test "purchases association" do
    refute defined?(@merchandise.purchases) == nil, 'no association between merchandises and purchases'
  end

  test "parse youtube for merchandise" do
    @merchandise.youtube = "http://youtube.com/watch?v=/frlviTJc"
    @merchandise.get_youtube_id
    refute_equal("http://youtube.com/watch?v=/frlviTJc", @merchandise.youtube)
  end

  test 'get_filename_and_data valid' do
    filename_and_data_all = @all_merchandises.each { |x| x.get_filename_and_data }
    @merchandise_attachments.each do |x|   
      assert_equal @all_merchandises.each { |p| p[x] }, filename_and_data_all.each { |q| q[x] }
    end
  end
 
end
