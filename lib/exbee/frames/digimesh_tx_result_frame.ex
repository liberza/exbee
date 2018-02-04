defmodule Exbee.DigiMeshTxResultFrame do
  @moduledoc """
  Received upon completion of a `Exbee.TxFrame` or `Exbee.ExplicitTxFrame`. The
  `:status` attribute indicates whether the transmission was successful.

  Possible status values include:

    * `:ok` (`0x00`)
    * `:mac_ack_failure` (`0x01`)
    * `:cca_failure` (`0x02`)
    * `:network_ack_failure` (`0x21`)
    * `:route_not_found` (`0x25`)
    * `:internal_resource_error` (`0x31`)
    * `:internal_error` (`0x31`)
    * `:oversized_payload` (`0x74`)
    * `:indirect_message_failure` (`0x75`)
  """

  @type t :: %__MODULE__{id: integer, network_addr: integer, retry_count: integer, status: integer,
                         discovery: integer}
  defstruct [id: 0x01, network_addr: nil, retry_count: 0, status: nil,
             discovery: nil]

  defimpl Exbee.DecodableFrame do
    @statuses %{
      0x00 => :ok,
      0x01 => :mac_ack_failure,
      0x02 => :cca_failure,
      0x21 => :network_ack_failure,
      0x25 => :route_not_found,
      0x31 => :internal_resource_error,
      0x32 => :internal_error,
      0x74 => :oversized_payload,
      0x75 => :indirect_message_failure,
    }

    @discoveries %{
      0x00 => :no_overhead,
      0x02 => :route,
    }

    def decode(frame, <<0x8B, id::8, 0xFFFE::16, network_addr::16, retry_count::8, status::8, discovery::8>>) do
      {:ok, %{frame | id: id, network_addr: network_addr, retry_count: retry_count,
               status: @statuses[status], discovery: @discoveries[discovery]}}
    end
  end
end
