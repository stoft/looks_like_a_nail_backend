defmodule LooksLikeANailBackend.UtilsTest do
  use ExUnit.Case, async: true

  alias LooksLikeANailBackend.Utils

  test "convert msecs from epoch to ISO date time" do
    expected = "2015-07-18T22:01:26.419Z"
    actual = Utils.convert_msecs_to_iso(1437256886419)
    assert expected == actual
  end

end