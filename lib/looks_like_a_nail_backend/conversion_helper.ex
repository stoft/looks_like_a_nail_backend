defmodule LooksLikeANailBackend.ConversionHelper do
  
  @doc """
  Converts a string or integer to an integer.
  iex> LooksLikeANailBackend.ConversionHelper.convert_to_integer(1)
  1
  iex> LooksLikeANailBackend.ConversionHelper.convert_to_integer("1")
  1
  """
  @spec convert_to_integer(integer|String.t) :: integer
  def convert_to_integer(input) when is_integer(input) do
    input
  end

  def convert_to_integer(input) do
    String.to_integer(input)
  end

  @doc """
  Converts msecs from epoch to ISO formatted datetime.

  iex> LooksLikeANailBackend.ConversionHelper.convert_msecs_to_iso(1437256886419)
  "2015-07-18T22:01:26.419Z"
  """
  use Timex
  @spec convert_msecs_to_iso(integer) :: String.t
  def convert_msecs_to_iso(msecs) do
    msecs
    |> Time.from(:msecs)
    |> Date.from(:timestamp)
    |> DateFormat.format("{ISOz}")
    |> elem(1)
  end
  
end