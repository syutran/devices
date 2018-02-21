require 'test_helper'

class DevicesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @device = devices(:one)
  end

  test "should get index" do
    get devices_url
    assert_response :success
  end

  test "should get new" do
    get new_device_url
    assert_response :success
  end

  test "should create device" do
    assert_difference('Device.count') do
      post devices_url, params: { device: { branch_id: @device.branch_id, changed_date: @device.changed_date, contacts: @device.contacts, custodian: @device.custodian, description: @device.description, dev_class: @device.dev_class, dev_model: @device.dev_model, invalided: @device.invalided, manufacturer: @device.manufacturer, parameter: @device.parameter, purchased: @device.purchased, seller: @device.seller, serial_number: @device.serial_number, status: @device.status, title: @device.title, used: @device.used, user: @device.user } }
    end

    assert_redirected_to device_url(Device.last)
  end

  test "should show device" do
    get device_url(@device)
    assert_response :success
  end

  test "should get edit" do
    get edit_device_url(@device)
    assert_response :success
  end

  test "should update device" do
    patch device_url(@device), params: { device: { branch_id: @device.branch_id, changed_date: @device.changed_date, contacts: @device.contacts, custodian: @device.custodian, description: @device.description, dev_class: @device.dev_class, dev_model: @device.dev_model, invalided: @device.invalided, manufacturer: @device.manufacturer, parameter: @device.parameter, purchased: @device.purchased, seller: @device.seller, serial_number: @device.serial_number, status: @device.status, title: @device.title, used: @device.used, user: @device.user } }
    assert_redirected_to device_url(@device)
  end

  test "should destroy device" do
    assert_difference('Device.count', -1) do
      delete device_url(@device)
    end

    assert_redirected_to devices_url
  end
end
