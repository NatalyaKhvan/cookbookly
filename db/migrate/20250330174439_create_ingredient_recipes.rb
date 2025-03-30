class CreateIngredientRecipes < ActiveRecord::Migration[8.0]
  def change
    create_table :ingredient_recipes do |t|
      t.decimal :quantity, null: false, precision: 10, scale: 2
      t.string :unit
      t.references :recipe, null: false, foreign_key: true
      t.references :ingredient, null: false, foreign_key: true
      t.timestamps
    end
  end
end
