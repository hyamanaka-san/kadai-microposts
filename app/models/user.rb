class User < ApplicationRecord
    before_save { self.email.downcase! }
    validates :name, presence: true, length: { maximum: 50 }
    validates :email,presence: true, length: { maximum: 255 },
                format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                uniqueness: { case_sensitive: false }
    has_secure_password
            
    has_many :microposts
    has_many :relationships
    has_many :followings, through: :relationships, source: :follow  
    has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
    has_many :followers, through: :reverses_of_relationship, source: :user
    
    has_many :favorites #userは多数のお気に入り投稿をもつ
    has_many :favoritings, through: :favorites, source: :micropost  #関数favoritingを定義。中間テーブルfavoritesを通してお気に入りされているmicropost_idを取得できるようにする。
                                                                    #user.favoriting メソッドを用いると自分のお気に入りリストを取得できるようになる。
                                                                    
    #has_many :reverses_of_favorite, class_name: 'Favorite', foreign_key:'micropost_id' # Favorite クラスを参照する reverses_of_favorite を作成。foreign_key:'micropost_id'によって、micropost_idから、お気に入りしているuserを出せるようにする。
                                                                                        
    #has_many :favorited, through: :reverses_of_favorite, source: :user #関数favoritedを定義。 reverses_of_favorite（favoritesと同義？） を通してるuser_idを取得できるようにする。

    
    def follow(other_user)
        unless self == other_user
            self.relationships.find_or_create_by(follow_id: other_user.id)
            
        end
    end

    def unfollow(other_user)
        relationship = self.relationships.find_by(follow_id: other_user.id)
        relationship.destroy if relationship
    end

    def following?(other_user)
        self.followings.include?(other_user)
    end
    
    def feed_microposts
        Micropost.where(user_id: self.following_ids + [self.id])
    end
    
    def favorite(micro)
        self.favorites.find_or_create_by(micropost_id: micro.id)
       # selfはお気に入りをしようとしているユーザー　つまり自分。microは引数の代入先なのでなんでも良い変数
    end
    
    def unfavorite(micro)
        favo = self.favorites.find_by(micropost_id: micro.id)
        favo.destroy if favo
    end
    
    def favoriting?(micro)
        self.favoritings.include?(micro)
    end
        
    
end
    

