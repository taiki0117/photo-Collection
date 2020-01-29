class Post < ApplicationRecord
  belongs_to :user  #postから見てuserは一人。この関連付けによりユーザーの紐付けなしでは投稿を保存できない。
  
  has_many :favorites, dependent: :destroy
  has_many :fav_users, through: :favorites, source: :user, dependent: :destroy
  
  validates :content, presence: true, length: { maximum: 255 }  #あとでimageのバリデーションも必要。
  validates :image, presence: true
  
  mount_uploader :image, ImageUploader
end
