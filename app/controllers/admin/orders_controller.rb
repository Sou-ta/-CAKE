class Admin::OrdersController < ApplicationController
  def show
    @order = Order.find(params[:id])
    @order_details = @order.order_details
  end

  def update
   	order = Order.find(params[:id])
   	status = params[:order][:status].to_i
    order.update(status: status)
     if order.status == "入金確認"
			order.order_details.update_all(making_status: 1)
     end
		redirect_to admin_order_path(order.id)
  end




  private

  def order_params
    params.require(:order).permit(:status)
  end
end
