class Ability
  include CanCan::Ability

  def initialize user, controller_namespace
    user ||= User.new
    case controller_namespace
    when Settings.namespace.admin
      if user.is_admin?
        can :manage, :all
        can :search_reported
      end
    else
      if user.is_admin?
        can :manage, :all
      else
        can :read, [HistoryDownload, User, Favorite, Document, Comment]
        can :create, [Category, Transaction, HistoryDownload,
          User, Favorite, Document, Comment], user_id: user.id
        can :destroy, [Favorite, Document, Comment], user_id: user.id
        can :update, [User], id: user.id
      end
    end
  end
end
