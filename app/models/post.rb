class Post < ApplicationRecord
  belongs_to :user  #postから見てuserは一人。この関連付けによりユーザーの紐付けなしでは投稿を保存できない。
  
  validates :content, presence: true, length: { maximum: 255 }  #あとでimageのバリデーションも必要。
  
  mount_uploader :image, ImageUploader
end
