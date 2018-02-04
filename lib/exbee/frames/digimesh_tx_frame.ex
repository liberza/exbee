defmodule Exbee.DigiMeshTxFrame do
  @moduledoc """
  Transmits a payload to a remote node, for XBee modules that support DigiMesh.

    * For broadcast transmissions, set `:mac_addr` to `0x000000000000FFFF`.

  The `:radius` attribute sets the maximum number of hops a broadcast transmission can occur. It can
  be set from `0` to `0xFF`. If set to 0, the value of the Maximum Unicast Hops(NH) command
  specifies the broadcast radius (recommended). This parameter is only used for broadcast
  transmissions.

  Possible `:option` values (use bitwise OR to combine non-delivery-method opts):

    * `0x01` - Disable acknowledgements on all unicasts
    * `0x02` - Disable route discovery on all DigiMesh unicasts
    * `0x04` - Enable NACK messages on all DigiMesh API packets
    * `0x08` - Enable a trace route on all DigiMesh API packets
    * `0x40` - Point->Multipoint delivery method
    * `0x80` - Repeater mode delivery method
    * `0xC0` - Digimesh delivery method

  An `Exbee.TxResultFrame` will be returned indicating the status of the transmission.
  """

  @type t :: %__MODULE__{id: integer, mac_addr: integer, radius: integer, options: integer, payload: binary}
  defstruct [id: 0x01, mac_addr: 0x000000000000FFFF, radius: 0x00, options: 0x00, payload: nil]

  defimpl Exbee.EncodableFrame do
    alias Exbee.Util

    def encode(%{id: id, mac_addr: mac_addr, radius: radius, options: options, payload: payload}) do
      binary_payload = Util.to_binary(payload)
      <<0x10, id::8, mac_addr::64, 0xFFFE::16, radius::8, options::8, binary_payload::binary>>
    end
  end
end
