class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :image
      t.string :content
      t.references :user, foreign_key: true #ここで投稿したユーザーを特定している

      t.timestamps
    end
  end
end
