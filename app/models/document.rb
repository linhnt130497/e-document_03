class Document < ApplicationRecord
  acts_as_paranoid
  belongs_to :user
  belongs_to :category
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :history_downloads, dependent: :destroy
  has_many :history_views, dependent: :destroy

  scope :order_by_created_at, ->{order created_at: :desc}
  scope :search_name, ->(name_doc){where "name_document LIKE ?", "%#{name_doc}%"}
  scope :search_category, ->(category_id){where "category_id = ?", category_id}
  scope :search_id, ->(document_ids){where "id IN (?)", document_ids}
  scope :status_illegal, ->(status){where is_illegal: status}
  scope :in_period_upload, ->(time_start, time_end) do
    where("created_at BETWEEN ? AND ?",
      time_start, time_end)
  end

  mount_uploader :content, DocumentUploader

  extend FriendlyId
  friendly_id :name_document, use: %i(slugged finders)
end
