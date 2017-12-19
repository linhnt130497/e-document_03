module UsersHelper
  def correct_user
    @user = User.find_by id: params[:id]
    return if current_user? @user
    flash[:danger] = t "users.flash.not_correct_user"
    redirect_to root_path
  end
end
