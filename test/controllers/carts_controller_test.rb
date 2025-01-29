require "test_helper"

class CartsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get carts_show_url
    assert_response :success
  end

  test "should get add_to_cart" do
    get carts_add_to_cart_url
    assert_response :success
  end

  test "should get remove_from_cart" do
    get carts_remove_from_cart_url
    assert_response :success
  end
end
