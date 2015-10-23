class Post < ActiveRecord::Base
  validates :title, :body, :tags, presence: true
  validates :title, uniqueness: true
  validates :title, length: { in: 5..100 }

end
