class ApplicationController < ActionController::Base
  before_action :initialize_cart

  private

  def initialize_cart
    session[:cart] ||= []
  end
end
