class CreateRecipes < ActiveRecord::Migration[8.0]
  def change
    create_table :recipes do |t|
      t.string :title, null: false
      t.text :instructions, null: false
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
