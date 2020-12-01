require 'test_helper'

class EmbedCodesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @embed_code = embed_codes(:one)
  end

  test "should get index" do
    get embed_codes_url
    assert_response :success
  end

  test "should get new" do
    get new_embed_code_url
    assert_response :success
  end

  test "should create embed_code" do
    assert_difference('Embedcode.count') do
      post embed_codes_url, params: { embed_code: { border: @embed_code.border, border_color: @embed_code.border_color, border_size: @embed_code.border_size, location: @embed_code.location, size: @embed_code.size, special_position: @embed_code.special_position } }
    end

    assert_redirected_to embed_code_url(Embedcode.last)
  end

  test "should show embed_code" do
    get embed_code_url(@embed_code)
    assert_response :success
  end

  test "should get edit" do
    get edit_embed_code_url(@embed_code)
    assert_response :success
  end

  test "should update embed_code" do
    patch embed_code_url(@embed_code), params: { embed_code: { border: @embed_code.border, border_color: @embed_code.border_color, border_size: @embed_code.border_size, location: @embed_code.location, size: @embed_code.size, special_position: @embed_code.special_position } }
    assert_redirected_to embed_code_url(@embed_code)
  end

  test "should destroy embed_code" do
    assert_difference('Embedcode.count', -1) do
      delete embed_code_url(@embed_code)
    end

    assert_redirected_to embed_codes_url
  end
end
