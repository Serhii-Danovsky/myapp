class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments

  acts_as_votable

  validates :title, :body, :tags, presence: true
  validates :title, uniqueness: true
  validates :title, length: {in: 5..140}
  validates :body, length: {minimum: 140}

  scope :newest, -> { order(created_at: :desc) }
  scope :popular, ->(posts) { posts.sort_by(&:score_up).last(3) }

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |post|
        csv << post.attributes.values_at(*column_names)
      end
    end
  end

  def score_up
    self.get_upvotes.size
  end

  def score_down
    self.get_downvotes.size
  end
end
