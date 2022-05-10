class Public::ItemsController < ApplicationController
  def index
    unless params[:commit].nil?
      @id = Genre.find_by(name: params[:commit])
      @items = Item.where(genre_id: @id)
    else
      @items = Item.all
    end
    @genre = Genre.all
  end
  
  def show
    @item = Item.find(params[:id])
    @genre = Genre.all
    @new_cart = CartItem.new
    @num_arr = [1, 2, 3, 4, 5, 6, 7, 8, 9]
  end

  private
  def delimiter_num(price)
    "#{price.to_s(:delimited, delimiter: ",")}"
  end
  helper_method :delimiter_num
end
