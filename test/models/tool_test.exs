defmodule LooksLikeANailBackend.ToolTest do
  use ExUnit.Case, async: true

  alias LooksLikeANailBackend.Tool
  import AssertMore
  # doctest LooksLikeANailBackend.Tool

  test "get create statement" do
    expected = {"CREATE (tool:Tool {props}) SET tool.id = id(tool), tool.updated = timestamp(), tool.created = timestamp() RETURN tool",
      %{props: %{title: "Foo"}}}
    assert expected == Tool.get_create_statement(%{title: "Foo"})
  end

  test "get update statement" do
    input = %{"created" => "2015-07-21T23:52:06.931Z", "description" => "DescriptionEndingWithDoubleQuote\"",
      "subTitle" => "Application",
      "title" => "TortoiseSVN",
      "updated" => "2015-07-29T18:39:22.104Z"}

    expected = {"MATCH (tool:Tool) WHERE tool.id = {id} SET tool.title = {title}, tool.subTitle = {subTitle}, tool.description = {description}, tool.updated = timestamp(), tool.keywords = {keywords} RETURN tool",
            %{description: "DescriptionEndingWithDoubleQuote\"", id: nil, keywords: nil, subTitle: "Application", title: "TortoiseSVN"}}
    actual = Tool.get_update_statement(input)
    assert expected === actual
  end

end