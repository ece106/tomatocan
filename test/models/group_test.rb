require 'test_helper'

class TestGroup < ActiveSupport::TestCase

  def setup
    @group = Group.new
  end

[:name, :latitude, :address, :user_id].each do |field|
  define_method "#{field.to_s}_must_not_be_empty" do
    @group = Group.new
    @group.send "#{field.to_s}=", nil
    refute @group.valid?
    refute_empty @group.errors[field]
  end
end

  def test_group_attributes_must_not_be_empty
#    assert @group.invalid?
#    assert @group.errors[:name].any?  
  end

end
