class Public::CartItemsController < ApplicationController
  before_action :authenticate_costomer!
  def index
    @items = CartItem.where(costomer_id: current_costomer.id)
    @num_arr = [1, 2, 3, 4, 5, 6, 7, 8, 9]
  end

  def update
    @item = CartItem.find(params[:id])
    if @item.update(str_params)
      redirect_to cart_items_path
    else
      render :index
    end
  end
  
  def destroy_all
    @in_cart = current_costomer.cart_items
    @in_cart.destroy_all
    redirect_to cart_items_path
  end

  def destroy
    @item = CartItem.find(params[:id])
    @item.destroy
    redirect_to cart_items_path
  end


  def create
    @in_cart = current_costomer.cart_items.find_by(item_id: str_params[:item_id])
    # カート内にすでに商品があるか検索
    if @in_cart # 商品があった場合
      if str_params[:amount] == "" # 数量がnilか？
        @item = Item.find(str_params[:item_id])
        @genre = Genre.all
        @new_cart = CartItem.new
        @num_arr = [*1..9]
        render template: "public/items/show"
        return 0
      else
        @sum = @in_cart.amount + params[:cart_item][:amount].to_i
      end
      if @in_cart.update(amount: @sum)
        redirect_to cart_items_path
      else
        @item = Item.find(str_params[:item_id])
        @genre = Genre.all
        @new_cart = CartItem.new
        @num_arr = [*1..9]
        render template: "public/items/show"
      end
    else # 商品がなかった場合
      if str_params[:amount] == "" # 数量がnilか？
        @item = Item.find(str_params[:item_id])
        @genre = Genre.all
        @new_cart = CartItem.new
        @num_arr = [*1..9]
        render template: "public/items/show"
        return 0
      end
      @new_cart_item = CartItem.new(str_params)
      @new_cart_item.costomer_id = current_costomer.id
      if @new_cart_item.save
        redirect_to cart_items_path
      else
        @item = Item.find(str_params[:item_id])
        @genre = Genre.all
        @new_cart = CartItem.new
        @num_arr = [*1..9]
        render template: "public/items/show"
      end
    end
  end

  private
  def str_params
    params.require(:cart_item).permit(:amount, :item_id)
  end
  def delimiter_num(price)
    "#{price.to_s(:delimited, delimiter: ",")}"
  end
  helper_method :delimiter_num
end
