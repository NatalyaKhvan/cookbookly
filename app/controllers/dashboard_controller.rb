class DashboardController < ApplicationController
    def index
        @recipes = Recipe.where(user_id: current_user.id) if current_user
    end
end