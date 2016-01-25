require 'test_helper'

class LabelTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @label_type = label_types(:one)
  end

  test "should get index" do
    get label_types_url
    assert_response :success
  end

  test "should get new" do
    get new_label_type_url
    assert_response :success
  end

  test "should create label_type" do
    assert_difference('LabelType.count') do
      post label_types_url, params: { label_type: { label_id: @label_type.label_id, name: @label_type.name } }
    end

    assert_redirected_to label_type_path(LabelType.last)
  end

  test "should show label_type" do
    get label_type_url(@label_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_label_type_url(@label_type)
    assert_response :success
  end

  test "should update label_type" do
    patch label_type_url(@label_type), params: { label_type: { label_id: @label_type.label_id, name: @label_type.name } }
    assert_redirected_to label_type_path(@label_type)
  end

  test "should destroy label_type" do
    assert_difference('LabelType.count', -1) do
      delete label_type_url(@label_type)
    end

    assert_redirected_to label_types_path
  end
end
