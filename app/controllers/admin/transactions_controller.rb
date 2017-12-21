module Admin
  class TransactionsController < ApplicationController
    before_action :find_transaction_user, only: %i(update destroy)
    before_action :check_transaction_not_own, only: %i(update destroy)
    authorize_resource

    def index
      @transactions = Transaction.exception_user(current_user.id)
        .order_by_created_at.status_confirm false
    end

    def update
      if @transaction.update_attributes(is_confirm: true)
        update_coin
        UserMailer.added_coin(@user, @transaction).deliver_now
        render json: {success: true, response_text: t(".success")}
      else
        render json: {success: false, response_text: t(".fail")}
      end
    end

    def destroy
      if @transaction.destroy
        UserMailer.ignore_transaction(@user, @transaction).deliver_now
        render json: {success: true, response_text: t(".success")}
      else
        render json: {success: false, response_text: t(".fail")}
      end
    end

    private

    def update_coin
      @user.update_attribute :coin, @user.coin.to_i + @transaction.coin.to_i
    end

    def find_transaction_user
      @transaction = Transaction.find_by id: params[:id]
      @user = @transaction.user
      return if @transaction && @user
      render json: {success: false, response_text: t(".not_found")}
    end

    def check_transaction_not_own
      return unless @transaction.user == current_user
      render json: {success: false, response_text: t(".not_found")}
    end
  end
end
