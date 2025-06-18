module RecipesHelper
    def formatted_ingredient(ir)
        [ ir.quantity, ir.unit, ir.ingredient.name ].compact.join(" ")
    end
end
