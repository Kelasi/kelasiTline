require 'our_date'

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

  def self.paginate(num)
    from_date = Date.last_thursday - 7*num
    to_date = from_date + 7
    to_date = Date.today + 1 if num == 0
    self.where(created_at: from_date..to_date)
  end
end
