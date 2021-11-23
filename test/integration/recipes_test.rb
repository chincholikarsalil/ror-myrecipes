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
  
end
