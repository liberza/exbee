defmodule Exbee.EndToEndTest do
  use Exbee.IntegrationCase
  alias Exbee.{ATCommandFrame, ATCommandResponseFrame}

  @moduletag :integration

  describe "enumerate/0" do
    test "returns each connected serial port" do
      assert is_map(Exbee.enumerate)
    end
  end

  describe "send_frame/2" do
    test "sends the frame and receives a response", %{device: device} do
      assert :ok = Exbee.send_frame(device, %ATCommandFrame{command: "NJ"})
      assert_receive {:exbee,  %ATCommandResponseFrame{command: "NJ", status: :ok}}
    end
  end
end