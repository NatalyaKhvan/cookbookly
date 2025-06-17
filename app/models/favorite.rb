class Favorite < ApplicationRecord
    belongs_to :user
    belongs_to :recipe

    validates :user, presence: true
    validates :recipe, presence: true
    validates :recipe_id, uniqueness: { scope: :user_id }
end
