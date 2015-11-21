class User < ActiveRecord::Base
  has_many :posts
  has_many :comments
  has_many :favorite_posts

  has_secure_password
  validates :email, format: {with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i}, uniqueness: true
  validates_presence_of :name

  def rating
    likes = self.posts.map(&:score_up).sum
    dislikes = self.posts.map(&:score_down).sum
    posts_count = self.posts.count
    posts_count + likes - dislikes
  end
end
