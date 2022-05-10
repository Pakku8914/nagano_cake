class Admin::OrdersController < ApplicationController
  before_action :authenticate_admin!
  layout "admin_app"
  def show
    @order = Order.find(params[:id])
    @order_details = @order.order_details
  end

  def update
    # 編集するレコードを取得
    @order = Order.find(params[:id])
    # Orderモデルに紐づいている注文詳細をすべて取得
    @details = @order.order_details
    ## 注文 ##
    # 送られてきたパラメータにorderがあるか？
    unless params[:order].nil?
      # 送られてきたstatusパラメータでupdate
      if @order.update(str_params_status)
        @details.each do |f|
          # 製作ステータスが製作不可で、送られてきたパラメータが入金確認なら
          if f.making_status == "impossible" && str_params_status["status"] == "conf_pay"
            # 製作ステータスを製作待ちに変更
            f.update(making_status: :wait)
          end
        end
      end
    end

    ## 注文詳細　##
    # 送られてきたパラメータにorder_detailはあるか？
    unless params[:order_detail].nil?
      # 編集するレコードを取得
      @detail = OrderDetail.find(params[:order_detail][:id])
      # レコードをupdate
      if @detail.update(str_params_making_status)
        # 注文ステータスが"入金確認"で、更新する情報が製作中なら
        if @order.status == "conf_pay" && str_params_making_status["making_status"] == "making"
          # 注文ステータスを"製作中"に変更
          @order.update(status: :making)
        end
      end
    end

    # 製作完了の真偽値
    finish = true

    @details.each do |f|
      # 一つでも製品が出来上がっていなければ
      if f.making_status != "made"
        finish = false
      end
    end

    # 注文詳細の製作ステータスが全て製作完了なら
    if finish
      @order.update(status: :sending_prepare)
    end

    redirect_to request.referer
  end

  private
  def str_params_status
    params.require(:order).permit(:status)
  end

  def str_params_making_status
    params.require(:order_detail).permit(:making_status)
  end
end
