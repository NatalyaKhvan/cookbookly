require 'rails_helper'

RSpec.describe Category, type: :model do
  describe "associations" do
    it "has many category_recipes" do
      assoc = Category.reflect_on_association(:category_recipes)
      expect(assoc.macro).to eq(:has_many)
    end

    it "has many recipes through category_recipes" do
      assoc = Category.reflect_on_association(:recipes)
      expect(assoc.macro).to eq(:has_many)
      expect(assoc.options[:through]).to eq(:category_recipes)
    end
  end

  describe "validations" do
    subject { Category.new(name: "Dessert") }

    it "is invalid without a name" do
      subject.name = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:name]).to include("can't be blank")
    end

    it "is valid with a name" do
      expect(subject).to be_valid
    end

    it "is invalid with a duplicate name" do
      Category.create!(name: "Dessert")
      duplicate = Category.new(name: "Dessert")
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:name]).to include("has already been taken")
    end
  end
end
