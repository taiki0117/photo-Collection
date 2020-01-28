class Relationship < ApplicationRecord
  belongs_to :user
  belongs_to :follow, class_name: "User" #User(クラス)モデルを参照するように指定している
end
