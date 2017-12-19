class HistoryDownloadsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_document, only: :create
  authorize_resource

  def create
    check_download
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
    current_user.update_attribute :down_count, current_user.down_count.to_i +
      Settings.history_downloads.down_times
  end

  def check_download
    down_times_in_month = current_user.history_downloads
      .in_period(Time.zone.now.beginning_of_month, Time.zone.now.end_of_month)
    if down_times_in_month.size < Settings.history_downloads.max_down_free
      download_document
    else
      download_document_coin
    end
  end

  def download_document
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

  def download_document_coin
    check_coin
  end

  def check_coin
    if current_user.coin >= Settings.history_downloads.cost_per_down
      return unless current_user.update_attribute :coin,
        current_user.coin.to_i - Settings.history_downloads.cost_per_down
      download_document
      update_coin_owner_document
    else
      flash[:warning] = t ".not_enough_coin"
      redirect_to request.referer || root_url
    end
  end

  def update_coin_owner_document
    user_owner = @document.user
    return if current_user? user_owner
    user_owner.update_attribute :coin,
      user_owner.coin.to_i + Settings.history_downloads.coin_owner_plus
  end
end
