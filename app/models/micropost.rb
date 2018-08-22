class Micropost < ApplicationRecord
  belongs_to :user
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.micropost.max_content}
  validate  :picture_size

  scope :post_new, ->{order(created_at: :desc)}
  scope :by_user_id, ->(id){where user_id: id}

  private
  def picture_size
    return unless picture.size > Settings.micropost.img_size.megabytes
    errors.add(:picture, t(".img_less_than"))
  end
end
