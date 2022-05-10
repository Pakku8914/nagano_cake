class Admin::CustomersController < ApplicationController
  before_action :authenticate_admin!
  # application.htmlではなく、admin_appを適応
  layout "admin_app"

  def index
    @users = Costomer.all
  end

  def show
    @user = Costomer.find(params[:id])
  end

  def edit
    @user = Costomer.find(params[:id])
  end

  def update
    @user = Costomer.find(params[:id])
    if @user.update(str_params)
      if params[:costomer][:is_deleted] == "active"
        @user.is_deleted = false
        @user.undiscard
      else
        @user.is_deleted = true
        @user.discard
      end
      redirect_to admin_customer_path
    else
      render :edit
    end
  end

  private
  def str_params
    params.require(:costomer).permit(:last_name, :email, :first_name,
                                     :last_name_kana, :first_name_kana,
                                     :postal_code, :address,
                                     :telephone_number, :is_deleted)
  end
end
