require 'test_helper'

class AlgowikiRelationsControllerTest < ActionController::TestCase
  setup do
    @algowiki_relation = algowiki_relations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:algowiki_relations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create algowiki_relation" do
    assert_difference('AlgowikiRelation.count') do
      post :create, algowiki_relation: {  }
    end

    assert_redirected_to algowiki_relation_path(assigns(:algowiki_relation))
  end

  test "should show algowiki_relation" do
    get :show, id: @algowiki_relation
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @algowiki_relation
    assert_response :success
  end

  test "should update algowiki_relation" do
    patch :update, id: @algowiki_relation, algowiki_relation: {  }
    assert_redirected_to algowiki_relation_path(assigns(:algowiki_relation))
  end

  test "should destroy algowiki_relation" do
    assert_difference('AlgowikiRelation.count', -1) do
      delete :destroy, id: @algowiki_relation
    end

    assert_redirected_to algowiki_relations_path
  end
end
