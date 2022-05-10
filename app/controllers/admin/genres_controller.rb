class Admin::GenresController < ApplicationController
  before_action :authenticate_admin!
  layout "admin_app"

  def index
    @new_genre = Genre.new
    @genres = Genre.all
  end

  def create
    @genre = Genre.new(str_params)
    if @genre.save
      redirect_to admin_genres_path
    else
      @genres = Genre.all
      @new_genre = Genre.new
      render :index
    end
  end

  def edit
    @genre = Genre.find(params[:id])
  end

  def update
    @genre = Genre.find(params[:id])

    if @genre.update(str_params)
      redirect_to admin_genres_path
    else
      render :edit
    end
  end

  private
  def str_params
    params.require(:genre).permit(:name)
  end
end
