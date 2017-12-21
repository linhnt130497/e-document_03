class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :omniauthable,
    :recoverable, :rememberable, :trackable, :validatable, :confirmable
  devise :omniauthable, omniauth_providers: %i(facebook google_oauth2)

  has_many :transactions, dependent: :nullify
  has_many :favorites, dependent: :destroy
  has_many :history_downloads, dependent: :destroy
  has_many :history_views, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :categories, dependent: :nullify
  has_many :documents, dependent: :destroy
  has_many :active_friends, class_name: Friend.name,
    foreign_key: :sender_id,
    dependent: :destroy
  has_many :sending, through: :active_friends, source: :accepter
  has_many :passive_friends, class_name: Friend.name,
    foreign_key: :accepter_id,
    dependent: :destroy
  has_many :accepting, through: :passive_friends, source: :sender

  before_save :downcase_email, :set_default

  validates :name, presence: true, length: {maximum: Settings.user.maximum_name}
  mount_uploader :avatar, AvatarUploader

  scope :friend_of_user, ->(array_friends_id){where "id IN (?)", array_friends_id}
  scope :user_by_ids, ->(user_ids){where id: user_ids}
  scope :order_by_created_at, ->{order created_at: :desc}
  scope :status_admin, ->(status){where "is_admin = ?", status}
  scope :not_login, ->(datetime){where "current_sign_in_at < ?", datetime}
  scope :search_users, ->(name_search){where "name LIKE ?", "%#{name_search}%"}

  def self.new_with_session params, session
    super.tap do |user|
      if (data = session["devise.facebook_data"])
        new_user user, data
        session.delete("devise.facebook_data")
      elsif (data = session["devise.google_data"])
        new_user user, data
        session.delete("devise.google_data")
      end
    end
  end

  def self.new_user user, data
    user.provider = data["provider"]
    user.uid = data["uid"]
    user.email = data["info"]["email"]
    user.name = data["info"]["name"]
  end

  def self.from_omniauth auth
    User.find_by provider: auth.provider, uid: auth.uid
  end

  def send_request_friend other_user
    sending << other_user
  end

  def is_friend? other_user
    sending.include?(other_user) || accepting.include?(other_user)
  end

  def is_favorite? document_id
    self.favorites.find_by document_id: document_id
  end

  private

  def downcase_email
    self.email = email.downcase
  end

  def set_default
    self.coin = Settings.user.default_coin
    self.up_count = Settings.user.default_count
    self.down_count = Settings.user.default_count
  end
end
