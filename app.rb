require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug" if development?
require "better_errors" if development?

require_relative 'lib/cookbook'
require_relative 'lib/recipe'

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

csv_file = File.join(__dir__, 'data/recipes.csv')
COOKBOOK = Cookbook.new(csv_file)

get "/" do
  erb :index
end

get "/recipes" do
  @recipes = COOKBOOK.all
  erb :index, layout: :layout
end

get "/recipes/new" do
  erb :new
end

post "/recipes/create" do
  name = params[:name]
  description = params[:description]
  rating = params[:rating]
  prep_time = params[:prep_time]
  new_recipe = Recipe.new(name, description, rating, prep_time)
  COOKBOOK.add_recipe(new_recipe)
  erb :index
end

post "/recipes/:recipe/update" do
  @recipe = Recipe.find(params[:recipe])
  cookbook.mark_as_done(@recipe)
  erb :show
end

post "/recipes/:recipe/delete" do
  recipe = Recipe.find(params[:recipe])
  cookbook.delete_recipe(recipe)
  erb :index
end

# get "/import" do
  # search_term = @view.ask_user_for("ingredient would you like a recipe for")
  # search_results = @view.import_recipes(search_term)
  # @view.display_search_results(search_results)
  # recipe_to_import = @view.ask_user_for("number of the recipe you'd like to import:").to_i

  # name = search_results[recipe_to_import - 1][0]
  # desc = search_results[recipe_to_import - 1][1]
  # rating = search_results[recipe_to_import - 1][2]
  # new_recipe = Recipe.new(name, desc, rating)
  # @cookbook.add_recipe(new_recipe)
# end
