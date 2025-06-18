require 'rails_helper'

RSpec.describe CategoryRecipe, type: :model do
  describe "associations" do
    it "belongs to a recipe" do
      assoc = CategoryRecipe.reflect_on_association(:recipe)
      expect(assoc.macro).to eq(:belongs_to)
    end

    it "belongs to a category" do
      assoc = CategoryRecipe.reflect_on_association(:category)
      expect(assoc.macro).to eq(:belongs_to)
    end
  end
end
