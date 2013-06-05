class Post < ActiveRecord::Base
  attr_accessible :msg, :user_id, :parent_id, :dir
  belongs_to :parent, class_name: "Post"
  has_many :replies, class_name: "Post", foreign_key: "parent_id",
    dependent: :destroy

  belongs_to :user

  default_scope -> { order 'created_at desc' }
  scope :recent_posts, ->(num=20) { where(parent_id: [0, nil]).limit(num) }

  validates :msg, presence: true
end
