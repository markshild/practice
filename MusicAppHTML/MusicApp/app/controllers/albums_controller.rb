class AlbumsController < ApplicationController
  before_action :require_login

  def index
    @albums = Album.all
  end

  def new
    @album = Album.new
    @bands = Band.all
  end

  def show
    @album = Album.find(params[:id])
  end

  def create
    @album = Album.new(album_params)
    @bands= Band.all
    if @album.save
      redirect_to album_url(@album)
    else
      flash.now[:errors] = @album.errors.full_messages
      render :new
    end
  end

  def edit
    @album = album.find(params[:id])
    @bands = Band.all
  end

  def update
    @album = Album.find(params[:id])
    @bands = Band.all
    if @album.update(album_params)
      redirect_to album_url(@album)
    else
      flash.now[:errors] = @album.errors.full_messages
      render :edit
    end
  end

  def destroy
    @album = Album.find(params[:id])
    @album.destroy
    redirect_to albums_url
  end

  private
  def album_params
    params.require(:album).permit(:name, :album_type, :band_id)
  end
end
