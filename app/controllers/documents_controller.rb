class DocumentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_document, only: %i(destroy show)
  before_action :load_data_comment, only: :show
  before_action :add_to_history_view, only: :show
  authorize_resource

  def show
    @document = Document.find_by id: params[:id]
    @comment = current_user.comments.build
    @favorite = current_user.favorites.find_by document_id: params[:id]
    return if @document
    flash[:danger] = t "documents.show.fail"
    redirect_to root_url
  end

  def destroy
    if document_illegal?(@document)
      @document.update_attribute :is_illegal, true
      delete_document @document
    elsif correct_document?(@document)
      delete_document @document
    else
      flash[:danger] = t "documents.destroy.fail"
    end
    redirect_to request.referer || root_url
  end

  def new
    @document = current_user.documents.build
    @category = current_user.categories.build
    @categories = Category.all
  end

  def create
    @document = current_user.documents.new document_params
    upload_in_month = current_user.documents
      .in_period_upload(Time.zone.now.beginning_of_month, Time.zone.now.end_of_month)
    if upload_in_month.size < Settings.documents.max_upload_in_month
      upload_document
    else
      upload_error
    end
  end

  private

  def upload_error
    flash[:danger] = t "documents.document.can_not_upload",
      count: Settings.documents.max_upload_in_month
    redirect_to request.referer || root_url
  end

  def upload_document
    if @document.save
      send_email
      update_count_upload
      update_coin
      flash[:success] = t "documents.upload_success"
      redirect_to request.referer || root_url
    else
      flash[:danger] = t "documents.upload_error"
      redirect_to root_path
    end
  end

  def update_coin
    current_user.update_attribute :coin,
      current_user.coin.to_i + Settings.documents.coin_per_upload
  end

  def update_count_upload
    current_user.update_attribute :up_count, current_user.up_count.to_i + 1
  end

  def find_document
    @document = Document.find_by id: params[:id]
    return if @document
    flash[:danger] = t "documents.error_find"
    redirect_to root_url
  end

  def document_params
    params.require(:document).permit :category_id, :name_document, :content
  end

  def correct_document? document
    document == current_user.documents.find_by(id: params[:id])
  end

  def delete_document document
    if document.destroy
      flash[:success] = t "documents.destroy.success"
    else
      flash[:danger] = t "documents.destroy.fail"
    end
  end

  def add_to_history_view
    @history_view = current_user.history_views.find_by document_id: @document.id
    return if @history_view && @history_view.update_attribute(:updated_at, Time.zone.now)
    @history_view = current_user.history_views.new document_id: @document.id
    return if @history_view.save
    flash[:danger] = t "documents.document.save_history"
    redirect_to root_path
  end

  def send_email
    DocumentMailer.upload_success(current_user).deliver_now
  end
end
