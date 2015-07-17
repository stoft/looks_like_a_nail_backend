defmodule LooksLikeANailBackend.Neo4J.RepoTest do
  use ExUnit.Case

  alias Neo4J.Repo
  alias LooksLikeANailBackend.Tool

  test "convert neo4j response to single Tool" do
    response = %{"errors" => [],
      "results" => [%{"columns" => ["tool"],
      "data" => [
        %{"row" => [
          %{"id" => 1, "title" => "Foo", "subTitle" => "Bar", "description" => "grill"}]}
        ]}
      ]}
    expected = %{id: 1, title: "Foo", subTitle: "Bar", description: "grill"}
    assert expected == Repo.convert_to_type(response, Tool)
  end

  test "convert neo4j response to multiple Tools" do
    response = %{"errors" => [],
      "results" => [
        %{"columns" => ["tool"],
        "data" => [
          %{"row" => [%{"id" => 1, "title" => "Foo", "subTitle" => "Bar", "description" => "grill"}]},
          %{"row" => [%{"id" => 2, "title" => "Baz", "subTitle" => "Olde", "description" => "verding"}]}
        ]}
      ]}
    expected = [%{id: 1, title: "Foo", subTitle: "Bar", description: "grill"},
      %{id: 2, title: "Baz", subTitle: "Olde", description: "verding"}]
    assert expected == Repo.convert_to_type(response, Tool)
  end
end