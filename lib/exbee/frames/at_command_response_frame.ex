defmodule Exbee.ATCommandResponseFrame do
  defstruct [id: 0x01, command: nil, status: nil, value: nil]

  defimpl Exbee.FrameDecoder do
    @statuses %{
      0x00 => :ok,
      0x01 => :error,
      0x02 => :invalid_command,
      0x03 => :invalid_parameter,
      0x04 => :transmition_failure,
    }

    def decode(frame, <<0x88, id::8, command::bitstring-size(16), status::8, value::binary>>) do
      {:ok, %{frame | id: id, command: command, status: @statuses[status], value: value}}
    end
  end
end
