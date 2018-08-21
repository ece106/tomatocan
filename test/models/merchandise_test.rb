require 'test_helper'

class MerchandiseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
   def setup
    @merchanise = merchandises(:one)
  end

  test "price should not be empty" do
    merchanise = Merchandise.new
    merchanise.send "price=",nil
    refute merchanise.valid?
    refute_empty merchanise.errors[:price]
  end

   test "parse youtube for merchanise" do
      @merchanise.youtube = "http://youtube.com/watch?v=/frlviTJc"
      @merchanise.get_youtube_id
      refute_equal("http://youtube.com/watch?v=/frlviTJc", @merchanise.youtube)
      end
end
