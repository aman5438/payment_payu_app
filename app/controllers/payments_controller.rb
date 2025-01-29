class PaymentsController < ApplicationController
  before_action :authenticate_user!

  def new
    @cart = session[:cart].map { |product_id| Product.find(product_id) }
    @total = @cart.sum(&:price)
  end

  def create
    @cart = session[:cart].map { |product_id| Product.find(product_id) }
    @total = @cart.sum(&:price)

    payment_params = {
      key: ENV['PAYU_MERCHANT_KEY'],
      salt: ENV['PAYU_MERCHANT_SALT'],
      txnid: "TXN#{SecureRandom.hex(5)}",
      amount: @total.to_s,
      productinfo: "Payment for products",
      firstname: current_user.email.split('@').first,
      email: current_user.email,
      phone: '9999999999',
      surl: success_payments_url,
      furl: failure_payments_url,
      service_provider: 'payu_paisa'
    }


    payment_params[:hash] = calculate_hash(payment_params)

    @payment_url = "https://#{ENV['PAYU_MODE'] == 'test' ? 'test' : 'secure'}.payu.in/_payment"
    @payment_params = payment_params
  end

  def success
    payment_status = params[:status]
    if payment_status == 'success'
      order = current_user.orders.create(
        total_amount: params[:amount],
        status: 'completed',
        payu_transaction_id: params[:txnid]
      )
      session[:cart] = [] # Clear the cart
      redirect_to root_path, notice: 'Payment successful!'
    else
      redirect_to root_path, alert: 'Payment failed!'
    end
  end

  def failure
    redirect_to root_path, alert: 'Payment failed!'
  end

  private

  def calculate_hash(payment_params)
    hash_string = "#{payment_params[:key]}|#{payment_params[:txnid]}|#{payment_params[:amount]}|#{payment_params[:productinfo]}|#{payment_params[:firstname]}|#{payment_params[:email]}|||||||||||#{payment_params[:salt]}"
    Digest::SHA512.hexdigest(hash_string)
  end
end