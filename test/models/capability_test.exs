defmodule LooksLikeANailBackend.CapabilityTest do
  use ExUnit.Case, async: true

  # doctest LooksLikeANailBackend.Capability

  test "get create statement" do
    statement = {"CREATE (capability:Capability {props}) SET capability.id = id(capability), capability.updated = timestamp(), capability.created = timestamp() RETURN task",
      %{props: %{title: "Foo"}}}
    assert statement == LooksLikeANailBackend.Capability.get_create_statement(%{title: "Foo"})
  end
end