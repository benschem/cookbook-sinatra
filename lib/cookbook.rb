require_relative 'recipe'
require "csv"

class Cookbook
  def initialize(csv_file_path)
    @csv_file_path = csv_file_path
    @recipes = []
    load_recipes_from_csv
  end

  def all
    @recipes
  end

  def add_recipe(new_recipe)
    @recipes << new_recipe
    push_recipes_to_csv
  end

  def delete_recipe(recipe_index)
    @recipes.delete_at(recipe_index - 1)
    push_recipes_to_csv
  end

  def mark_as_done(recipe_index)
    @recipes[recipe_index - 1].mark_as_done!
    push_recipes_to_csv
  end

  private

  def load_recipes_from_csv
    CSV.foreach(@csv_file_path, headers: true, header_converters: :symbol) do |row|
      row[:done] = row[:done] == "true"
      row[:rating] = row[:rating].to_i
      row[:prep_time] = row[:prep_time].to_i
      new_recipe = Recipe.new(row)
      @recipes << new_recipe
    end
  end

  def push_recipes_to_csv
    CSV.open(@csv_file_path, "wb") do |csv|
      csv << %w[name description rating prep_time done]
      @recipes.each do |recipe|
        csv << [recipe.name, recipe.description, recipe.rating, recipe.prep_time, recipe.done]
      end
    end
  end
end
