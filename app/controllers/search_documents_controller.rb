class SearchDocumentsController < ApplicationController
  before_action :authenticate_user!, only: %i(search_deleted search_reported)
  before_action :checked_admin, only: :search_reported
  before_action :correct_user, only: :search_deleted

  def search_name
    @documents = Document.search_name(params[:document][:name_document])
      .paginate page: params[:page]
    @categories = Category.all
  end

  def search_category
    @documents = Document.search_category(params[:id]).paginate page: params[:page]
    render partial: "search_category"
  end

  def search_reported
    @reports = Comment.status_report(true).group_by(&:document_id)
    @documents = Document.search_id(@reports.keys).paginate page: params[:page]
  end

  def search_deleted
    @documents = @user.documents.only_deleted.paginate page: params[:page]
  end
end
