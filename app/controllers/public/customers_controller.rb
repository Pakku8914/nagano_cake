class Public::CustomersController < ApplicationController
  def show
    @user = current_costomer
  end

  def edit
    @customer = current_costomer
  end

  def update
    @customer = current_costomer
    if @customer.update(update_str_params)
      redirect_to my_page_path
    else
      render :edit
    end
  end

  def exit
  end

  def withdraw
    # 退会ステータスを更新
    current_costomer.is_deleted = true
    # discardを用いて論理削除
    current_costomer.discard
    # ログアウト処理を実行
    reset_session
    redirect_to root_path
  end

  private
  def update_str_params
    params.require(:costomer).permit(:last_name, :email, :first_name,
                                     :last_name_kana, :first_name_kana,
                                     :postal_code, :address,
                                     :telephone_number)
  end

end
