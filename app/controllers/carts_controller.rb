class CartsController < ApplicationController
  def show
    @cart = session[:cart].map { |product_id| Product.find(product_id) }
    @total = @cart.sum(&:price)
  end

  def add_to_cart
    session[:cart] << params[:product_id]
    redirect_to cart_path, notice: 'Product added to cart!'
  end

  def remove_from_cart
    session[:cart].delete(params[:product_id])
    redirect_to cart_path, notice: 'Product removed from cart!'
  end
end