class Public::OrdersController < ApplicationController
  def new
    @order = Order.new
    @customer = current_customer
    @addresses = Address.new
  end

  def comp
    @cart_items = CartItem.all
    @total_price = @cart_items.sum{|cart_item|cart_item.item.price * cart_item.amount * 1.1}
    @order = Order.new(order_params)
    @order.customer_id = current_customer.id
    destination = params[:order][:a_method].to_i
    @order.postage = 800


    if params[:order][:a_method] == "0"
      @order.postal_code = current_customer.postal_code
      @order.address = current_customer.address
      @order.name = current_customer.last_name + current_customer.first_name
    elsif params[:order][:a_method] == "1"
      @address = Address.find_by(params[:order][:address])
      @order.postal_code = @address.postal_code
      @order.address = @address.address
      @order.name = @address.name
    elsif params[:order][:a_method] == "2"

    end
  end

  def create
    @order = Order.new(order_params)
		@order.total_payment = params[:order][:total_payment]

    @order.status = 0
    @order.postage = 800
    if @order.save
       current_customer.cart_items.each do |cart|
         order_detail = OrderDetail.new
         order_detail.order_id = @order.id
         order_detail.item_id = cart.item_id
         order_detail.amount = cart.amount
         order_detail.price = cart.item.full_price
         order_detail.making_status = 0
         order_detail.save
    end
      current_customer.cart_items.destroy_all
      redirect_to orders_thanx_path
    else
      render :new
    end
  end

  def thanx
  end

  def index
    @cart_items = current_customer.cart_items
    @orders = current_customer.orders.page(params[:page]).per(8).order(created_at: :desc)
  end

  def show
    @order = Order.find(params[:id])
    @order_details = @order.order_details
  end

  private

  def order_params
  params.require(:order).permit(:customer_id, :payment_method, :postal_code, :postage, :total_payment, :address, :name, :status)


  end

  def order_detail_params
    params.require(:order_details).permit(:order_id, :item_id, :amount, :price, :making_status)
  end

end
