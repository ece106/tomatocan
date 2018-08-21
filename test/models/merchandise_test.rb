require 'test_helper'

class MerchandiseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
   def setup
    @merchandise = merchandises(:one)
  end

  test "price should not be empty" do
    merchandise = Merchandise.new
    merchandise.send "price=",nil
    refute merchandise.valid?
    refute_empty merchandise.errors[:price]
  end

   test "parse youtube for merchanise" do
      @merchandise.youtube = "http://youtube.com/watch?v=/frlviTJc"
      @merchandise.get_youtube_id
      refute_equal("http://youtube.com/watch?v=/frlviTJc", @merchandise.youtube)
      end
end
