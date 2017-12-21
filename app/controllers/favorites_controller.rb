class FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_favorite, only: %i(destroy)
  authorize_resource

  def index
    if params[:format]
      find_document
      @favorites = @document.favorites.order_by_created_at
        .paginate page: params[:page]
      render "index_users"
    else
      @favorites = current_user.favorites.order_by_created_at
        .paginate page: params[:page]
    end
  end

  def create
    @favorite = current_user.favorites.new document_id: params[:document_id]
    if @favorite && @favorite.save
      reponse_action
    else
      flash[:danger] = t "favorite.add_error"
      redirect_to request.referer || root_url
    end
  end

  def destroy
    if @favorite && @favorite.destroy
      reponse_action
    else
      flash[:danger] = t "favorite.un_error"
      redirect_to request.referer || root_url
    end
  end

  private

  def find_favorite
    @favorite = Favorite.find_by id: params[:id]
    return if @favorite
    flash[:danger] = t "favorite.error_find"
    redirect_to root_path
  end

  def find_document
    @document = Document.find_by slug: params[:format]
    return if @document
    flash[:danger] = t "search_documents.search_category.not_found"
    redirect_to root_path
  end

  def reponse_action
    @document = @favorite.document
    respond_to do |format|
      format.html{}
      format.js
    end
  end
end
