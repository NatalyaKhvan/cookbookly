class Ingredient < ApplicationRecord
    has_many :ingredient_recipes
    has_many :recipes, through: :ingredient_recipes

    validates :name, presence: true, uniqueness: { message: "already exists in the list." }

    before_destroy :ensure_not_used_in_recipes

    private

    def ensure_not_used_in_recipes
        if recipes.exists?
            errors.add(:base, "Cannot delete ingredient still used in recipes.")
            throw(:abort)
        end
    end
end
