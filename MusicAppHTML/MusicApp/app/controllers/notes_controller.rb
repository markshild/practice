class NotesController < ApplicationController
  before_action :require_login

  def create
    @note = Note.new(note_params)
    @note.user_id = current_user.id
    @note.track_id = params[:track_id]
    @note.save
    flash.now[:errors] = @note.errors.full_messages
    redirect_to track_url(params[:track_id])
  end

  def destroy
    id = params[:track_id]
    note = Note.find(params[:id])
    if note.user_id == current_user.id || admin
      note.destroy
    else
      flash.now[:errors] = ["nice try, bub!"]
    end
    redirect_to track_url(id)
  end

  private
  def note_params
    params.require(:note).permit(:body)
  end

end
