class CreateFavoritePosts < ActiveRecord::Migration
  def change
    create_table :favorite_posts do |t|
      t.references :user
      t.references :post
      t.timestamps null: false
    end
  end
end
