require 'test_helper'

class ChefTest < ActiveSupport::TestCase
  
  def setup
    @chef = Chef.new(chefname: "john", email: "john@example.com")
  end

  test "should be valid" do 
    assert @chef.valid?
  end
  
  test "chefame should be present" do
    @chef.chefname = ""
    assert_not @chef.valid?
  end
  
  test "email should be present" do
    @chef.email = ""
    assert_not @chef.valid?
  end

  test "chefname shouldn't be less than 4 characters" do
    @chef.chefname = "a" * 3
    assert_not @chef.valid?
  end
  
  test "chefname shouldn't be more than 30 characters" do
    @chef.chefname = "a" * 31
    assert_not @chef.valid?
  end
  
  test "email shouldn't be more than 200 characters" do
    @chef.email = "a" * 195 + "@example.com"
    assert_not @chef.valid?
  end
  
  test "should accept valid emails" do
    valid_emails = %w[user@example.com salil@gmail.com john+smith@co.uk.org]
    valid_emails.each do |email|
      @chef.email = email
      assert @chef.valid?, "#{email.inspect} should be valid"
    end
  end
  
  test "should reject invalid emails" do
    invalid_emails = %w[user@example salil@gmail,com john+smith@co,uk.org, joe@exam.]
    invalid_emails.each do |email|
      @chef.email = email
      assert_not @chef.valid?, "#{email.inspect} should be invalid"
    end
  end
  
  test "email should be unique and case insensitive" do
    duplicate_chef = @chef.dup
    duplicate_chef.email = @chef.email.upcase
    @chef.save
    assert_not duplicate_chef.valid?
  end
  
  test "email should be lower case before hitting db" do
    mixed_email = "JohN@eXamPle.Com"
    @chef.email = mixed_email
    @chef.save
    assert_equal mixed_email.downcase, @chef.reload.email
  end
  
end