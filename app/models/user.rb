class User < ActiveRecord::Base
  has_many :posts
  has_many :comments
  has_many :favorite_posts

  has_secure_password
  validates_presence_of :name
  #validates_length_of :name, maximum: 10

  def rating
    likes = self.posts.map(&:score_up).sum
    dislikes = self.posts.map(&:score_down).sum
    posts_count = self.posts.count
    posts_count + likes - dislikes
  end
end
