defmodule LooksLikeANailBackend.Utils do
  use Timex

  @doc """
  Converts msecs from epoch to ISO formatted datetime.

  iex> LooksLikeANailBackend.Utils.convert_msecs_to_iso(1437256886419)
  "2015-07-18T22:01:26.419Z"
  """
  def convert_msecs_to_iso(msecs) do
    msecs
    |> Time.from(:msecs)
    |> Date.from(:timestamp)
    |> DateFormat.format("{ISOz}")
    |> elem(1)
  end
  
end