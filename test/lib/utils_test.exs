defmodule LooksLikeANailBackend.UtilsTest do
  use ExUnit.Case, async: true

  alias LooksLikeANailBackend.Utils

  test "get an ISO formatted UTC timestamp" do
    timestamp = Utils.get_timestamp_now()
    pattern = ~r/\d{4}-\d{2}-\d{2}T(\d\d:){2}\d{2}.\d{3}\+\d{4}/
    assert Regex.match?(pattern, timestamp)
  end
  
end