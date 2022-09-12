class Admin::GenresController < ApplicationController
  def index
    @genre = Genre.new
    @genres = Genre.all
  end
  def create
    @genre = Genre.new(genre_params)
    if @genre.save
      flash[:notice] = "新しいジャンルを追加しました"
      redirect_to admin_genres_path
    else
      @genres = Genre.all
      render :index
    end
  end

  def edit
    @genre = Genre.find(params[:id])
  end

  def update
    @genre = Genre.find(params[:id])
    if @genre.update(genre_params)
      flash[:notice] = "名前を変更しました"
      redirect_to admin_genres_path
    else
      @genre = Genre.all
      render :edit
    end
  end

  private

  def genre_params
    params.require(:genre).permit(:name)
  end

end
