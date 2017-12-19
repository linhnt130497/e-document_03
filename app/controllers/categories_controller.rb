class CategoriesController < ApplicationController
  load_and_authorize_resource

  def create
    @category = current_user.categories.build
    @category.style = params[:style]
    unless @category && @category.save
      @category.errors.add :save, t("categories.create.save_fail")
    end
    @categories = Category.all
    @document = current_user.documents.build
    render partial: "documents/form"
  end
end
