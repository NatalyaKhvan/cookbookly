# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# Creating Categories
category1 = Category.create(name: "Desserts")
category2 = Category.create(name: "Main Course")
category3 = Category.create(name: "Appetizers")

# Creating Users
user1 = User.create(username: "john_smith", email: "john@etest.com")
user2 = User.create(username: "jane_clark", email: "jane@test.com")

# Creating Ingredients
ingredient1 = Ingredient.create(name: "Sugar")
ingredient2 = Ingredient.create(name: "Flour")
ingredient3 = Ingredient.create(name: "Eggs")
ingredient4 = Ingredient.create(name: "Chicken")

# Creating Recipes
recipe1 = Recipe.create(title: "Chocolate Cake", instructions: "Mix all ingredients and bake.", user: user1)
recipe2 = Recipe.create(title: "Grilled Chicken", instructions: "Season the chicken and grill it.", user: user2)
recipe3 = Recipe.create(title: "Caesar Salad", instructions: "Mix lettuce, dressing, and croutons.", user: user1)

# Adding Ingredients to Recipes
IngredientRecipe.create(recipe: recipe1, ingredient: ingredient1, quantity: 2, unit: "cups")
IngredientRecipe.create(recipe: recipe1, ingredient: ingredient2, quantity: 1, unit: "cup")
IngredientRecipe.create(recipe: recipe2, ingredient: ingredient4, quantity: 1, unit: "whole")

# Assigning Recipes to Categories
CategoryRecipe.create(recipe: recipe1, category: category1)
CategoryRecipe.create(recipe: recipe2, category: category2)
CategoryRecipe.create(recipe: recipe3, category: category3)

# Creating Reviews
Review.create(recipe: recipe1, user: user2, content: "Delicious!", rating: 5)
Review.create(recipe: recipe2, user: user1, content: "Tasty but a bit dry.", rating: 3)
Review.create(recipe: recipe3, user: user2, content: "Perfect for a light lunch.", rating: 4)

# Creating Favorites
Favorite.create(recipe: recipe1, user: user2)
Favorite.create(recipe: recipe2, user: user1)
