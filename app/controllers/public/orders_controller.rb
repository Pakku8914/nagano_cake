class Public::OrdersController < ApplicationController
  before_action :cancel_transition, only: [:new, :confirm, :create]
  before_action :authenticate_costomer!

  def new
    @new_order = Order.new
    @addresses = current_costomer.addresses
  end

  def confirm
    # オーダーの作成
    @new_order = Order.new
    # 送料
    @new_order.shipping_cost = 800
    # 支払方法
    @new_order.payment_method = params[:order][:payment_method]
    # アドレスの選択方法で場合分け
    case params[:order][:send_address]
    # ユーザー住所を使用する
    when "0" then
      # 名前を保存
      @new_order.name = current_costomer.last_name + current_costomer.first_name
      # 住所を保存
      @new_order.address = current_costomer.address
      # 郵便番号を保存
      @new_order.postal_code = current_costomer.postal_code
    # 登録済み住所を使用する
    when "1" then
      # 住所を検索
      @temp = Address.find(params[:order][:address_id])
      # 検索結果の住所を代入
      @new_order.postal_code = @temp.postal_code
      @new_order.address = @temp.address
      @new_order.name = @temp.name
    # 住所を新規で登録する
    when "2" then
      @address = Address.new(str_params_new_address)
      @new_order.address = @address.address
      @new_order.postal_code = @address.postal_code
      @new_order.name = @address.name
    end
    render :confirm
  end

  def thanks
  end

  def create
    @new_order = Order.new(str_params)
    @new_order.costomer_id = current_costomer.id
    # 新規でデータが入力されていれば
    if params[:order][:create_address] == "1"
      @new_address = Address.new(str_params_new_address)
      @new_address.costomer_id = current_costomer.id
      @new_address.save
    end
    if @new_order.save
      # カート内アイテムを取得
      @cart_items = current_costomer.cart_items
      # カート内アイテムを一つずつ処理(注文詳細を作成)
      @cart_items.each do |one_item|
        # 注文詳細を作成
        order = OrderDetail.new
        # アイテムIDを保存
        order.item_id = one_item.item_id
        # 注文IDを保存
        order.order_id = @new_order.id
        # 注文量を保存
        order.amount = one_item.amount
        # 購入時価格を保存
        order.price = one_item.item.price
        # 注文詳細を作成出来れば・・・
        if order.save
          # カート内アイテムをすべて削除
          @in_cart = current_costomer.cart_items
          @in_cart.destroy_all
        end
      end
      redirect_to orders_thanks_path
    else
      render :confirm
    end
  end

  def index

  end

  def show

  end

  private
  def str_params
    params.require(:order).permit(:payment_method, :postal_code, :name, :address,:shipping_cost, :total_payment)
  end

  def str_params_new_address
    params.require(:order).permit(:postal_code, :address, :name)
  end

  def delimiter_num(price)
    "#{price.to_s(:delimited, delimiter: ",")}"
  end

  def cancel_transition
    @cart = current_costomer.cart_items
    unless @cart.any?
      redirect_to cart_items_path
    end
  end
  helper_method :delimiter_num
end
