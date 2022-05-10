# frozen_string_literal: true

class Customer::SessionsController < Devise::SessionsController
  # サインインの判定
  before_action :with_drawed_customer, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  protected
  # サインイン時の退会しているかの判定
  def with_drawed_customer
    # Costomerモデルから入力されたメールアドレスを検索する
    @customer = Costomer.find_by(email: params[:costomer][:email])
    # 検索結果が出たら
    if @customer
      # パスワードが一致、且つ論理削除されているとき
      if @customer.valid_password?(params[:costomer][:password]) && @customer.discarded?
        # フラッシュメッセージの保存
        flash[:error] = "退会済みです"
        # ログイン画面に遷移
        redirect_to new_costomer_session_path
      end
    end
  end

end
