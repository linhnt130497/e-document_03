class TransactionsController < ApplicationController
  authorize_resource

  def create
    @user = current_user
    @transaction = current_user.transactions.new transaction_params
    unless @user && @transaction && @transaction.save
      @transaction.errors.add :save, t("transaction.save_fail")
    end
    UserMailer.buy_coin(@user, @transaction).deliver_now
    render partial: "shared/user_info"
  end

  private

  def transaction_params
    params.permit :coin, :cost_at_buy
  end
end
