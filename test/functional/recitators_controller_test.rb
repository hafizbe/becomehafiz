require 'test_helper'

class RecitatorsControllerTest < ActionController::TestCase
  setup do
    @recitator = recitators(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:recitators)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create recitator" do
    assert_difference('Recitator.count') do
      post :create, recitator: { name: @recitator.name, value: @recitator.value }
    end

    assert_redirected_to recitator_path(assigns(:recitator))
  end

  test "should show recitator" do
    get :show, id: @recitator
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @recitator
    assert_response :success
  end

  test "should update recitator" do
    put :update, id: @recitator, recitator: { name: @recitator.name, value: @recitator.value }
    assert_redirected_to recitator_path(assigns(:recitator))
  end

  test "should destroy recitator" do
    assert_difference('Recitator.count', -1) do
      delete :destroy, id: @recitator
    end

    assert_redirected_to recitators_path
  end
end
