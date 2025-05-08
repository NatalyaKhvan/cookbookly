class HomeController < ApplicationController
    def index
        @recipes = Recipe.limit(5)
    end
end
