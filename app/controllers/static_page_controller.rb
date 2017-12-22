class StaticPageController < ApplicationController
  def home
    @categories = Category.all
    @search = Document.search params[:q]
    @documents = @search.result.order_by_created_at.paginate(
      page: params[:page], per_page: params[:limit])
    return unless user_signed_in?
    @user = current_user
  end
end
