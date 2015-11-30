class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  acts_as_votable

  validates :title, :body, :tags, :image, presence: true
  validates :title, uniqueness: true
  validates :title, length: {in: 5..140}
  validates :body, length: {minimum: 140}

  scope :newest, -> { order(created_at: :desc) }
  scope :popular, ->(posts) { posts.sort_by(&:score_up).last(3).reverse }
  scope :active, -> { order(:updated_at).last(3).reverse }

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |post|
        csv << post.attributes.values_at(*column_names)
      end
    end
  end

  def self.search_by_tag(tag)
    if tag
      where('lower(tags) LIKE ?', "%#{tag.downcase}%")
    else
      all.newest
    end
  end

  def self.index_tags(params)
    search_by_tag(params[:tag])
  end

  def score_up
    self.get_upvotes.size
  end

  def score_down
    self.get_downvotes.size
  end
end
