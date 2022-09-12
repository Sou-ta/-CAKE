class Admin::OrderDetailsController < ApplicationController
  def update
    order_detail = OrderDetail.find(params[:id])
    making_status = params[:order_detail][:making_status].to_i
    order_detail.update(making_status: making_status)
    case order_detail.making_status
			when "製作中"
					order_detail.order.update(status: "製作中")
			when "製作完了"
				if order_detail.order.order_details.all?{|order_detail| order_detail.making_status == "製作完了"}
					order_detail.order.update(status: "発送準備中")
				end
		end
    redirect_to admin_order_path(order_detail.order.id)
  end


	private
   def order_detail_params
		 params.require(:order_detail).permit(:making_status)
	 end
end
