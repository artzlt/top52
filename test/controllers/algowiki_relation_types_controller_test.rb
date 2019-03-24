require 'test_helper'

class AlgowikiRelationTypesControllerTest < ActionController::TestCase
  setup do
    @algowiki_relation_type = algowiki_relation_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:algowiki_relation_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create algowiki_relation_type" do
    assert_difference('AlgowikiRelationType.count') do
      post :create, algowiki_relation_type: {  }
    end

    assert_redirected_to algowiki_relation_type_path(assigns(:algowiki_relation_type))
  end

  test "should show algowiki_relation_type" do
    get :show, id: @algowiki_relation_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @algowiki_relation_type
    assert_response :success
  end

  test "should update algowiki_relation_type" do
    patch :update, id: @algowiki_relation_type, algowiki_relation_type: {  }
    assert_redirected_to algowiki_relation_type_path(assigns(:algowiki_relation_type))
  end

  test "should destroy algowiki_relation_type" do
    assert_difference('AlgowikiRelationType.count', -1) do
      delete :destroy, id: @algowiki_relation_type
    end

    assert_redirected_to algowiki_relation_types_path
  end
end
