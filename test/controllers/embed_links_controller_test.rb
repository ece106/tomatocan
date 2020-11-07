require 'test_helper'

class EmbedLinksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @embed_link = embed_links(:one)
  end

  test "should get index" do
    get embed_links_url
    assert_response :success
  end

  test "should get new" do
    get new_embed_link_url
    assert_response :success
  end

  test "should create embed_link" do
    assert_difference('EmbedLink.count') do
      post embed_links_url, params: { embed_link: { border: @embed_link.border, border_color: @embed_link.border_color, border_size: @embed_link.border_size, location: @embed_link.location, size: @embed_link.size, special_position: @embed_link.special_position } }
    end

    assert_redirected_to embed_link_url(EmbedLink.last)
  end

  test "should show embed_link" do
    get embed_link_url(@embed_link)
    assert_response :success
  end

  test "should get edit" do
    get edit_embed_link_url(@embed_link)
    assert_response :success
  end

  test "should update embed_link" do
    patch embed_link_url(@embed_link), params: { embed_link: { border: @embed_link.border, border_color: @embed_link.border_color, border_size: @embed_link.border_size, location: @embed_link.location, size: @embed_link.size, special_position: @embed_link.special_position } }
    assert_redirected_to embed_link_url(@embed_link)
  end

  test "should destroy embed_link" do
    assert_difference('EmbedLink.count', -1) do
      delete embed_link_url(@embed_link)
    end

    assert_redirected_to embed_links_url
  end
end
