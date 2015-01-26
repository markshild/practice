class TracksController < ApplicationController
  before_action :require_login

  def index
    @tracks = Track.all
  end

  def new
    @track = Track.new
    album = Album.find(params[:album_id])
    @albums = Album.where(band_id: album.band_id)
  end

  def show
    @track = Track.find(params[:id])
  end

  def create
    @track = Track.new(track_params)
    album = Album.find(params[:track][:album_id])
    @albums = Album.where(band_id: album.band_id)
    if @track.save
      redirect_to track_url(@track)
    else
      flash.now[:errors] = @track.errors.full_messages
      render :new
    end
  end

  def edit
    @track = Track.find(params[:id])
    @albums = Album.where(band_id: @track.album.band_id)
  end

  def update
    @track = Track.find(params[:id])
    @albums = Album.where(band_id: @track.album.band_id)
    if @track.update(track_params)
      redirect_to track_url(@track)
    else
      flash.now[:errors] = @track.errors.full_messages
      render :edit
    end
  end

  def destroy
    @track = Track.find(params[:id])
    @track.destroy
    redirect_to tracks_url
  end

  private
  def track_params
    params.require(:track).permit(:name, :track_type, :lyrics, :album_id)
  end
end
