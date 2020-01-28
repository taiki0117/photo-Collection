class CreateRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :relationships do |t|
      t.references :user, foreign_key: true                     #referencesは他のテーブルを参照するという意味
      t.references :follow, foreign_key: { to_table: :users }   #followテーブルはないので、usersテーブルを参照させている

      t.timestamps
      
      t.index [:user_id, :follow_id], unique: true  #user_id, follow_idのペアで重複するものが保存されないようにしている
    end
  end
end
