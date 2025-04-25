class FavoritesController < ApplicationController
    def index
      @favorites = Favorite.all
    end

    def show
      @favorite = Favorite.find(params[:id])
    end
end
