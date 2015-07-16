defmodule LooksLikeANailBackend.Utils do
  use Timex

  @doc """
  Generates an ISO formatted timestamp for the current UTC date and time.

  iex> LooksLikeANailBackend.Utils.get_timestamp_now()
  "2015-07-16T08:15:30.729+0000"
  """
  def get_timestamp_now() do
    Date.now |> DateFormat.format("{ISO}") |> elem(1)
  end
end