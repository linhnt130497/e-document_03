class StaticPageController < ApplicationController
  def home
    @documents = Document.order_by_created_at.paginate page: params[:page]
    @categories = Category.all
    return unless user_signed_in?
    @user = current_user
  end
end
