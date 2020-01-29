class User < ApplicationRecord
    before_save { self.email.downcase! }                                        #インスタンスを保存する前に実行。文字を全て小文字に変換する。
    validates :name, presence: true, length: { maximum: 50 }                    #nameは空を許さず、長さは50文字以内
    validates :email, presence: true, length: { maximum: 255 },                 #emailは空を許さず、長さは255文字以内
                      format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },   #アドレスが正しい形式になっているか確認している
                      uniqueness: { case_sensitive: false } #登録の重複を許さない。大文字と小文字を区別しない。
    
    
    mount_uploader :image, ImageUploader
    
    has_secure_password    #パスワード付きのモデルなので使用。usersテーブルにパスワードを保存する時暗号化される。
    
    has_many :posts, dependent: :destroy     #userから見てpostは複数。この関連付けにより投稿が紐付けになる。
    
    has_many :relationships, dependent: :destroy     #自分がたくさんのrelationshipsを持つよという意味
    
    has_many :followings, through: :relationships, source: :follow, dependent: :destroy  #自分は[followings]で[relationships]を介して[follow]と繋がるよという意味
    
    has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id', dependent: :destroy
    #[reverses_of_relationship]は12行目の[relationships]と名前がかぶるので、名前を変えて逆方向の自分は[relationships]をたくさん持つよと示している
    #[class_name: 'Relationship']は[reverses_of_relationship]というクラスが存在しないので[relationships]を参照すると示している
    #[foreign_key: 'follow_id']は自分はuser_idではなく、反対側にいるfollw_idだと示している
    
    has_many :followers, through: :reverses_of_relationship, source: :user, dependent: :destroy  #自分は[followers]で逆方法にいるから[reverses_of_relationship]を介して[user]と繋がるよという意味
    
    has_many :favorites, dependent: :destroy
    has_many :fav_posts, through: :favorites, source: :post, dependent: :destroy
    
    def follow(other_user)
      unless self == other_user #self には user.follow(other) を実行したとき user が代入される。
        self.relationships.find_or_create_by(follow_id: other_user.id)  #フォロー関係を保存(create = build + save)することができる
      end
    end
    
    def unfollow(other_user)    #フォローがあればアンフォローしている
      relationship = self.relationships.find_by(follow_id: other_user.id)
      relationship.destroy if relationship
    end
    
    def following?(other_user)
      self.followings.include?(other_user)    #self.followings によりフォローしている User 達を取得し、include?(other_user) によって other_user が含まれていないかを確認している。
    end
    
    def feed_posts   #タイムライン用
      Post.where(user_id: self.following_ids + [self.id])   #Post.where(user_id: フォローユーザ + 自分自身)となるPostを全て取得している
    end
    
    
    def favorite(other_post)
      unless self == other_post
        self.favorites.find_or_create_by(post_id: other_post.id)
      end
    end
    
    def unfavorite(other_post)
      favorite = self.favorites.find_by(post_id: other_post.id)
      favorite.destroy if favorite
    end
    
    def checkfavorite?(other_post)
      self.fav_posts.include?(other_post)
    end
end