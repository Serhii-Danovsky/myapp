class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :post
  belongs_to :commentable, polymorphic: true
  has_many :comments, as: :commentable

  validates_presence_of :body, :user
  after_create { self.post.touch if post }
end
