class Post < ActiveRecord::Base
 belongs_to :user
 has_many :comments
  validates :title, :body, :tags, presence: true
  validates :title, uniqueness: true
  validates :title, length: { in: 5..100 }

def self.to_csv(options = {})
  CSV.generate(options) do |csv|
    csv << column_names
    all.each do |post|
      csv << post.attributes.values_at(*column_names)
    end
  end
end
end
