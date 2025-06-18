class User < ApplicationRecord
    has_secure_password

    has_many :recipes
    has_many :reviews
    has_many :favorites
    has_many :favorite_recipes, through: :favorites, source: :recipe

    validates :username, presence: true, uniqueness: true, length: { minimum: 3 }
    validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
end
