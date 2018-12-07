defmodule Servantex.DeviceManagerTest do
  use Servantex.DataCase

  alias Servantex.DeviceManager

  describe "controllers" do
    alias Servantex.DeviceManager.Controller

    @valid_attrs %{extras: %{}, is_enabled: true, name: "some name", secret: "some secret", type: "some type"}
    @update_attrs %{extras: %{}, is_enabled: false, name: "some updated name", secret: "some updated secret", type: "some updated type"}
    @invalid_attrs %{extras: nil, is_enabled: nil, name: nil, secret: nil, type: nil}

    def controller_fixture(attrs \\ %{}) do
      {:ok, controller} =
        attrs
        |> Enum.into(@valid_attrs)
        |> DeviceManager.create_controller()

      controller
    end

    test "list_controllers/0 returns all controllers" do
      controller = controller_fixture()
      assert DeviceManager.list_controllers() == [controller]
    end

    test "get_controller!/1 returns the controller with given id" do
      controller = controller_fixture()
      assert DeviceManager.get_controller!(controller.id) == controller
    end

    test "create_controller/1 with valid data creates a controller" do
      assert {:ok, %Controller{} = controller} = DeviceManager.create_controller(@valid_attrs)
      assert controller.extras == %{}
      assert controller.is_enabled == true
      assert controller.name == "some name"
      assert controller.secret == "some secret"
      assert controller.type == "some type"
    end

    test "create_controller/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = DeviceManager.create_controller(@invalid_attrs)
    end

    test "update_controller/2 with valid data updates the controller" do
      controller = controller_fixture()
      assert {:ok, %Controller{} = controller} = DeviceManager.update_controller(controller, @update_attrs)
      assert controller.extras == %{}
      assert controller.is_enabled == false
      assert controller.name == "some updated name"
      assert controller.secret == "some updated secret"
      assert controller.type == "some updated type"
    end

    test "update_controller/2 with invalid data returns error changeset" do
      controller = controller_fixture()
      assert {:error, %Ecto.Changeset{}} = DeviceManager.update_controller(controller, @invalid_attrs)
      assert controller == DeviceManager.get_controller!(controller.id)
    end

    test "delete_controller/1 deletes the controller" do
      controller = controller_fixture()
      assert {:ok, %Controller{}} = DeviceManager.delete_controller(controller)
      assert_raise Ecto.NoResultsError, fn -> DeviceManager.get_controller!(controller.id) end
    end

    test "change_controller/1 returns a controller changeset" do
      controller = controller_fixture()
      assert %Ecto.Changeset{} = DeviceManager.change_controller(controller)
    end
  end

  describe "devices" do
    alias Servantex.DeviceManager.Device

    @valid_attrs %{extras: %{}, is_enabled: true, name: "some name", traits: [], type: "some type"}
    @update_attrs %{extras: %{}, is_enabled: false, name: "some updated name", traits: [], type: "some updated type"}
    @invalid_attrs %{extras: nil, is_enabled: nil, name: nil, traits: nil, type: nil}

    def device_fixture(attrs \\ %{}) do
      {:ok, device} =
        attrs
        |> Enum.into(@valid_attrs)
        |> DeviceManager.create_device()

      device
    end

    test "list_devices/0 returns all devices" do
      device = device_fixture()
      assert DeviceManager.list_devices() == [device]
    end

    test "get_device!/1 returns the device with given id" do
      device = device_fixture()
      assert DeviceManager.get_device!(device.id) == device
    end

    test "create_device/1 with valid data creates a device" do
      assert {:ok, %Device{} = device} = DeviceManager.create_device(@valid_attrs)
      assert device.extras == %{}
      assert device.is_enabled == true
      assert device.name == "some name"
      assert device.traits == []
      assert device.type == "some type"
    end

    test "create_device/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = DeviceManager.create_device(@invalid_attrs)
    end

    test "update_device/2 with valid data updates the device" do
      device = device_fixture()
      assert {:ok, %Device{} = device} = DeviceManager.update_device(device, @update_attrs)
      assert device.extras == %{}
      assert device.is_enabled == false
      assert device.name == "some updated name"
      assert device.traits == []
      assert device.type == "some updated type"
    end

    test "update_device/2 with invalid data returns error changeset" do
      device = device_fixture()
      assert {:error, %Ecto.Changeset{}} = DeviceManager.update_device(device, @invalid_attrs)
      assert device == DeviceManager.get_device!(device.id)
    end

    test "delete_device/1 deletes the device" do
      device = device_fixture()
      assert {:ok, %Device{}} = DeviceManager.delete_device(device)
      assert_raise Ecto.NoResultsError, fn -> DeviceManager.get_device!(device.id) end
    end

    test "change_device/1 returns a device changeset" do
      device = device_fixture()
      assert %Ecto.Changeset{} = DeviceManager.change_device(device)
    end
  end

  describe "device_controls" do
    alias Servantex.DeviceManager.DeviceControl

    @valid_attrs %{action: %{}, trait: "some trait"}
    @update_attrs %{action: %{}, trait: "some updated trait"}
    @invalid_attrs %{action: nil, trait: nil}

    def device_control_fixture(attrs \\ %{}) do
      {:ok, device_control} =
        attrs
        |> Enum.into(@valid_attrs)
        |> DeviceManager.create_device_control()

      device_control
    end

    test "list_device_controls/0 returns all device_controls" do
      device_control = device_control_fixture()
      assert DeviceManager.list_device_controls() == [device_control]
    end

    test "get_device_control!/1 returns the device_control with given id" do
      device_control = device_control_fixture()
      assert DeviceManager.get_device_control!(device_control.id) == device_control
    end

    test "create_device_control/1 with valid data creates a device_control" do
      assert {:ok, %DeviceControl{} = device_control} = DeviceManager.create_device_control(@valid_attrs)
      assert device_control.action == %{}
      assert device_control.trait == "some trait"
    end

    test "create_device_control/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = DeviceManager.create_device_control(@invalid_attrs)
    end

    test "update_device_control/2 with valid data updates the device_control" do
      device_control = device_control_fixture()
      assert {:ok, %DeviceControl{} = device_control} = DeviceManager.update_device_control(device_control, @update_attrs)
      assert device_control.action == %{}
      assert device_control.trait == "some updated trait"
    end

    test "update_device_control/2 with invalid data returns error changeset" do
      device_control = device_control_fixture()
      assert {:error, %Ecto.Changeset{}} = DeviceManager.update_device_control(device_control, @invalid_attrs)
      assert device_control == DeviceManager.get_device_control!(device_control.id)
    end

    test "delete_device_control/1 deletes the device_control" do
      device_control = device_control_fixture()
      assert {:ok, %DeviceControl{}} = DeviceManager.delete_device_control(device_control)
      assert_raise Ecto.NoResultsError, fn -> DeviceManager.get_device_control!(device_control.id) end
    end

    test "change_device_control/1 returns a device_control changeset" do
      device_control = device_control_fixture()
      assert %Ecto.Changeset{} = DeviceManager.change_device_control(device_control)
    end
  end
end
