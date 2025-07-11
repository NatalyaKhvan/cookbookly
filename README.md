# Cookbookly

Cookbookly is a recipe-sharing platform for food enthusiasts, home cooks, and anyone who loves discovering and sharing delicious dishes. Users can create, browse, and review recipes to share their favorites with the community.

## Features

- User registration and authentication
- Create, update, and delete recipes
- Search recipes by title, ingredient, or category
- Write and read reviews for recipes
- Mark recipes as favorites

## Technologies Used

- Ruby on Rails
- SQLite

## Setup Instructions

1. Clone the repository:

   ```bash
   git clone https://github.com/NatalyaKhvan/cookbookly.git
   cd cookbookly
   ```

2. Install dependencies:

   ```bash
   bundle install
   ```

3. Set up the database:

   ```bash
   rails db:create db:migrate
   ```

4. Seed the database with sample data:

   ```bash
   rails db:seed
   ```

5. Start the Rails server:

   ```bash
   rails server
   ```

6. Open your browser and go to:
   ```
   http://localhost:3000
   ```
