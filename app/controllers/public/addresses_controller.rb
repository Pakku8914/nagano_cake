class Public::AddressesController < ApplicationController
  def index
    @addresses = current_costomer.addresses
    @new_address = Address.new
  end

  def edit
    @address = Address.find(params[:id])
  end

  def create
    @new_address = Address.new(str_params)
    @new_address.costomer_id = current_costomer.id
    if @new_address.save
      redirect_to addresses_path
    else
      @addresses = current_costomer.addresses
      render :index
    end
  end

  def update
    @address = Address.find(params[:id])
    if @address.update(str_params)
      redirect_to addresses_path
    else
      render :edit
    end
  end

  def destroy
    @address = Address.find(params[:id])
    @address.destroy
    redirect_to addresses_path
  end

  private
  def str_params
    params.require(:address).permit(:name, :postal_code, :address)
  end
end
