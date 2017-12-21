class HistoryViewsController < ApplicationController
  before_action :authenticate_user!

  def index
    @history_views = current_user.history_views.order_by_updated_at
      .includes(:document).paginate page: params[:page]
  end
end
