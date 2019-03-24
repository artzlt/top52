require 'test_helper'

class AlgowikiEntitiesControllerTest < ActionController::TestCase
  setup do
    @algowiki_entity = algowiki_entities(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:algowiki_entities)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create algowiki_entity" do
    assert_difference('AlgowikiEntity.count') do
      post :create, algowiki_entity: {  }
    end

    assert_redirected_to algowiki_entity_path(assigns(:algowiki_entity))
  end

  test "should show algowiki_entity" do
    get :show, id: @algowiki_entity
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @algowiki_entity
    assert_response :success
  end

  test "should update algowiki_entity" do
    patch :update, id: @algowiki_entity, algowiki_entity: {  }
    assert_redirected_to algowiki_entity_path(assigns(:algowiki_entity))
  end

  test "should destroy algowiki_entity" do
    assert_difference('AlgowikiEntity.count', -1) do
      delete :destroy, id: @algowiki_entity
    end

    assert_redirected_to algowiki_entities_path
  end
end
