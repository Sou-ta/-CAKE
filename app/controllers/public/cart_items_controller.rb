class Public::CartItemsController < ApplicationController
  def index
    @cart_items = current_customer.cart_items
    @total_price = @cart_items.sum{|cart_item|cart_item.item.price * cart_item.amount * 1.1}
  end

  def create
    @cart_item = CartItem.new(cart_item_params)
    @cart_item.customer_id = current_customer.id
   if current_customer.cart_items.find_by(item_id: params[:cart_item][:item_id]).present?
       cart_item = current_customer.cart_items.find_by(item_id: params[:cart_item][:item_id])
       cart_item.amount += params[:cart_item][:amount].to_i
       cart_item.update(amount: cart_item.amount)
      flash[:notice] = "#{@cart_item.item.name}をカートに追加しました。"
      redirect_to cart_items_path
   else if  @cart_item.save
      flash[:notice] = "#{@cart_item.item.name}をカートに追加しました。"
      redirect_to cart_items_path
   else
      flash[:alert] = "個数を選択してください"
      @item = @cart_item.item
      render "public/items/show"
   end
   end
  end

  def update
    @cart_item = CartItem.find(params[:id])
    @cart_item.update(cart_item_params)
    redirect_to cart_items_path
  end

    # カート商品を一つのみ削除
    def destroy
        @cart_item = CartItem.find(params[:id])
        @cart_item.destroy
        flash[:notice] = "#{@cart_item.item.name}を削除しました"
        redirect_to cart_items_path
    end

    # カート商品を空ににする
    def destroy_all
        @cart_item = current_customer.cart_items
        @cart_item.destroy_all
        flash[:notice] = "カートの商品を全て削除しました"
        redirect_to cart_items_path
    end

  private

  def cart_item_params
   params.require(:cart_item).permit(:item_id, :customer_id, :amount)
  end
end
