require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  fixtures :posts
  
  test "getting index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:posts)
  end

  test "showing topic" do
    get :show, {:id => posts(:topic).id}
    assert_response :success
    assert_not_nil assigns(:post)
  end

  test "creating post" do
    @request.env["HTTP_REFERER"] = posts_path
    assert_difference('Post.count') do
      post :create, :post => {:content => 'Testing post'}
    end
    assert_redirected_to posts_path
  end


end
