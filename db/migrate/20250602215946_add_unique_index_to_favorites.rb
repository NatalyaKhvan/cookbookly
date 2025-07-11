class AddUniqueIndexToFavorites < ActiveRecord::Migration[8.0]
  def change
    add_index :favorites, [ :user_id, :recipe_id ], unique: true
  end
end
