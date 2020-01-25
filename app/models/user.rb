class User < ApplicationRecord
    before_save { self.email.downcase! }                                        #インスタンスを保存する前に実行。文字を全て小文字に変換する。
    validates :name, presence: true, length: { maximum: 50 }                    #nameは空を許さず、長さは50文字以内
    validates :email, presence: true, length: { maximum: 255 },                 #emailは空を許さず、長さは255文字以内
                      format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },   #アドレスが正しい形式になっているか確認している
                      uniqueness: { case_sensitive: false }                     #登録の重複を許さない。大文字と小文字を区別しない。
    
    has_secure_password    #パスワード付きのモデルなので使用。usersテーブルにパスワードを保存する時暗号化される。
end