class Post < ActiveRecord::Base
  attr_accessible :msg, :user_id, :parent_id, :dir, :status
  belongs_to :parent, class_name: "Post"
  has_many :replies, class_name: "Post", foreign_key: "parent_id",
    dependent: :destroy

  belongs_to :user

  default_scope -> { order('created_at desc').where(status: 1) }
  scope :recent_posts, ->(num=20) { where(parent_id: [0, nil]).limit(num) }

  validates :msg, presence: true

  def message=(message)
    context = {gfm: true, asset_root: '/images'}
    pipeline = HTML::Pipeline.new [
      HTML::Pipeline::MarkdownFilter,
      HTML::Pipeline::SanitizationFilter,
      HTML::Pipeline::EmojiFilter,
      HTML::Pipeline::MentionFilter
    ], context
    result = pipeline.call message
    self.msg = result[:output].to_s
  end
end
