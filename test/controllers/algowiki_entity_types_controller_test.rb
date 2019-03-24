require 'test_helper'

class AlgowikiEntityTypesControllerTest < ActionController::TestCase
  setup do
    @algowiki_entity_type = algowiki_entity_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:algowiki_entity_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create algowiki_entity_type" do
    assert_difference('AlgowikiEntityType.count') do
      post :create, algowiki_entity_type: {  }
    end

    assert_redirected_to algowiki_entity_type_path(assigns(:algowiki_entity_type))
  end

  test "should show algowiki_entity_type" do
    get :show, id: @algowiki_entity_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @algowiki_entity_type
    assert_response :success
  end

  test "should update algowiki_entity_type" do
    patch :update, id: @algowiki_entity_type, algowiki_entity_type: {  }
    assert_redirected_to algowiki_entity_type_path(assigns(:algowiki_entity_type))
  end

  test "should destroy algowiki_entity_type" do
    assert_difference('AlgowikiEntityType.count', -1) do
      delete :destroy, id: @algowiki_entity_type
    end

    assert_redirected_to algowiki_entity_types_path
  end
end
