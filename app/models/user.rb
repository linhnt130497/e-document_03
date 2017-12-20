class User < ApplicationRecord
  before_create :default_user
  devise :database_authenticatable, :confirmable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :lockable

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

  mount_uploader :avatar, AvatarUploader

  scope :friend_of_user, ->(array_friends_id){where "id IN (?)", array_friends_id}
  scope :user_by_ids, ->(user_ids){where id: user_ids}
  scope :order_by_created_at, ->{order created_at: :desc}
  scope :status_admin, ->(status){where "is_admin = ?", status}
  scope :not_login, ->(datetime){where "login_last_at < ?", datetime}
  scope :search_users, ->(name_search){where "name LIKE ?", "%#{name_search}%"}

  def send_request_friend other_user
    sending << other_user
  end

  def is_friend? other_user
    sending.include?(other_user) || accepting.include?(other_user)
  end

  def is_favorite? document_id
    self.favorites.find_by document_id: document_id
  end

  def default_user
    self.coin ||= 20
    self.up_count ||= 0
    self.down_count ||= 0
  end
end
