require 'test_helper'

class RecipesTest < ActionDispatch::IntegrationTest
  
  def setup
    @chef = Chef.create!(chefname: "john", email: "john@example.com")
    @recipe1 = Recipe.create(name: "new recipe", description: "description of new recipe", chef: @chef)
    @recipe2 = @chef.recipes.build(name: "another new recipe", description: "new description for another recipe")
    @recipe2.save
  end
  
  test "should get recipes index" do
    get recipes_url
    assert_response :success
  end
  
  test "should get recipes listing" do
    get recipes_url
    assert_template 'recipes/index'
    assert_select "a[href=?]", recipe_url(@recipe1), text: @recipe1.name
    assert_select "a[href=?]", recipe_url(@recipe2), text: @recipe2.name
  end
  
  test "should get recipes show" do
    get recipe_url(@recipe1)
    assert_template 'recipes/show'
    assert_match @recipe1.name, response.body
    assert_match @recipe1.description, response.body
    assert_match @chef.chefname, response.body
  end
  
  test "create new valid recipe" do
    get new_recipe_url
    assert_template 'recipes/new'
    name_of_recipe = "new recipe name"
    description_of_recipe = "description of recipe"
    assert_difference 'Recipe.count', 1 do 
      post recipes_url, params: {recipe: {name: name_of_recipe, description: description_of_recipe}}
    end
    follow_redirect!
    assert_match name_of_recipe.capitalize, response.body
    assert_match description_of_recipe, response.body
  end

  test "reject invalid recipe submissions" do
    get new_recipe_url
    assert_template 'recipes/new'
    assert_no_difference 'Recipe.count' do 
      post recipes_url, params: {recipe: {name: "", description: ""}}
    end
    assert_template 'recipes/new'
    assert_select 'h4.error-title'
    assert_select 'div.error-body'
  end
  
end
