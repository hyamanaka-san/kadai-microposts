class Micropost < ApplicationRecord
    belongs_to :user
    
    has_many :favorites, dependent: :destroy # micropostは多くのお気に入りをもつ（もたれる）
    has_many :favorited, through: :favorites, source: :user  #関数favoritedを定義。中間テーブルfavoritesを通してお気に入りされているuser_idを取得できるようにする。

 
    validates :content, presence: true, length: { maximum: 255 }
    

    
    
    
end
    