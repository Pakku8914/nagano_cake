class Admin::ItemsController < ApplicationController
  before_action :authenticate_admin!
  layout "admin_app"

  def search
    @items = Item.search(params[:keyword])
    @keyword = params[:keyword]
    render :index
  end

  def index
    @items = Item.all
  end

  def new
    @new_item = Item.new
    @genres = Genre.pluck("name")
  end

  def create
    @item = Item.new(str_params)
    @item.genre_id = Genre.find_by(name: params[:item][:genre]).id
    if @item.save
      redirect_to admin_item_path(@item)
    else
      @new_item = Item.new
      @genres = Genre.pluck("name")
      render :new
    end
  end

  def show
    @item = Item.find(params[:id])
  end

  def edit
    @item = Item.find(params[:id])
    @genres = Genre.pluck("name")
  end

  def update
    @item = Item.find(params[:id])
    if @item.update(str_params)
      redirect_to admin_item_path(@item)
    else
      @genres = Genre.pluck("name")
      render :edit
    end
  end

  private
  def str_params
    params.require(:item).permit(:name, :introduction, :price, :is_active, :image)
  end

  def delimiter_num(price)
    "#{price.to_s(:delimited, delimiter: ",")}"
  end
  helper_method :delimiter_num
end
