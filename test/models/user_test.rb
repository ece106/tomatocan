require 'test_helper'

class TestUser < ActiveSupport::TestCase
  test "user attributes must not be empty" do
    user = User.new
    assert product.invalid?
    assert product.errors[:name].any?
    assert product.errors[:email].any?
    assert product.errors[:address].any?
    assert product.errors[:password].any?
  end
end
