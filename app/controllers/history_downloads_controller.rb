class HistoryDownloadsController < ApplicationController
  before_action :logged_in_user, only: :create
  before_action :find_document, only: :create

  def create
    @history = current_user.history_downloads.new
    @history.document_id = @document.id
    if @history.save
      update_count_download
      send_file @document.content.path
    else
      flash[:danger] = t "history_download.error"
      redirect_to root_url
    end
  end

  def index
    @histories = current_user.history_downloads.paginate page: params[:page]
  end

  private

  def find_document
    @document = Document.find_by id: params[:document_id]
    return if @document
    flash[:danger] = t "documents.error_find"
    redirect_to root_url
  end

  def update_count_download
    current_user.update_attribute :down_count, current_user.down_count.to_i + 1
  end
end
