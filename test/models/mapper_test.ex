defmodule LooksLikeANailBackend.MapperTest do
  use ExUnit.Case, async: true

  alias LooksLikeANailBackend.Mapper
  alias LooksLikeANailBackend.Tool
  import AssertMore

  @json_one_tool_first_row "{ \"row\": [ { \"title\": \"Elixir\", \"id\": 104, \"created\": 1437522726931, \"updated\": 1438197525156, \"subTitle\": \"Programming Langugage\", \"description\": \"Elixir is a functional...\" }, { \"title\": \"ecto\", \"id\": 302, \"created\": 1437522726931, \"updated\": 1437522726931 }, { \"title\": \"Connecting\", \"id\": 204, \"created\": 1437522726931, \"updated\": 1437522726931, \"subTitle\": \"Capability\", \"description\": \"ConnectingDescription\" }, { \"id\": 3024 }, { \"title\": \"MySQL\", \"id\": 106, \"created\": 1437522726931, \"updated\": 1438195241244, \"subTitle\": \"Database\", \"description\": \"MySQL (/maɪ ˌɛskjuːˈɛl/ 'My S-Q-L',[6] officially...\" } ] }"
  @json_one_tool_second_row "{\"row\": [ { \"title\": \"Elixir\", \"id\": 104, \"created\": 1437522726931, \"updated\": 1438197525156, \"subTitle\": \"Programming Langugage\", \"description\": \"Elixir is a functional...\" }, { \"title\": \"ecto\", \"id\": 302, \"created\": 1437522726931, \"updated\": 1437522726931 }, { \"title\": \"Connecting\", \"id\": 204, \"created\": 1437522726931, \"updated\": 1437522726931, \"subTitle\": \"Capability\", \"description\": \"ConnectingDescription\" }, { \"id\": 3023 }, { \"title\": \"Postgres\", \"id\": 105, \"created\": 1437522726931, \"updated\": 1438194844405, \"subTitle\": \"Database\", \"description\": \"PostgreSQL, often simply Postgres...\" } ]}"

  @json_row_one_tool_no_features "{ \"row\": [ { \"title\": \"Java\", \"id\": 101, \"created\": 1437522726931, \"updated\": 1438195114593, \"subTitle\": \"Programming Language\", \"description\": \"Java is a general-purpose computer programming language...\" }, null, null, null, null, null, null ] }"
  
  @columns ["tool","feature","capability","supports","concept"]

  test "map tools" do
    json = "{ \"columns\": [ \"tool\", \"feature\", \"capability\", \"supports\", \"concept\" ], \"data\": [ { \"row\": [ { \"title\": \"Java\", \"id\": 101, \"created\": 1437522726931, \"updated\": 1438195114593, \"subTitle\": \"Programming Language\", \"description\": \"Java is a general-purpose computer programming language...\" }, null, null, null, null ] }, { \"row\": [ { \"title\": \"Elixir\", \"id\": 104, \"created\": 1437522726931, \"updated\": 1438197525156, \"subTitle\": \"Programming Langugage\", \"description\": \"Elixir is a functional, concurrent, general-purpose programming language...\" }, { \"title\": \"ecto\", \"id\": 302, \"created\": 1437522726931, \"updated\": 1437522726931 }, { \"title\": \"Connecting\", \"id\": 204, \"created\": 1437522726931, \"updated\": 1437522726931, \"subTitle\": \"Capability\", \"description\": \"ConnectingDescription\" }, { \"id\": 3024 }, { \"title\": \"MySQL\", \"id\": 106, \"created\": 1437522726931, \"updated\": 1438195241244, \"subTitle\": \"Database\", \"description\": \"MySQL (/maɪ ˌɛskjuːˈɛl/ 'My S-Q-L',[6] officially...\" } ] }, { \"row\": [ { \"title\": \"Elixir\", \"id\": 104, \"created\": 1437522726931, \"updated\": 1438197525156, \"subTitle\": \"Programming Langugage\", \"description\": \"Elixir is a functional, concurrent, general-purpose programming language...\" }, { \"title\": \"ecto\", \"id\": 302, \"created\": 1437522726931, \"updated\": 1437522726931 }, { \"title\": \"Connecting\", \"id\": 204, \"created\": 1437522726931, \"updated\": 1437522726931, \"subTitle\": \"Capability\", \"description\": \"ConnectingDescription\" }, { \"id\": 3023 }, { \"title\": \"Postgres\", \"id\": 105, \"created\": 1437522726931, \"updated\": 1438194844405, \"subTitle\": \"Database\", \"description\": \"PostgreSQL, often simply Postgres, is an object-relational database...\" } ] }, { \"row\": [ { \"title\": \"Heroku\", \"id\": 107, \"created\": 1437522726931, \"updated\": 1438195289879, \"subTitle\": \"Platform as a Service\", \"description\": \"Heroku is a cloud platform as a service (PaaS)...\" }, { \"title\": \"herokuHosting\", \"id\": 305, \"created\": 1437522726931, \"updated\": 1437522726931 }, { \"title\": \"Hosting\", \"id\": 202, \"created\": 1437522726931, \"updated\": 1437522726931, \"subTitle\": \"Capability\", \"description\": \"HostingDescription\" }, { \"id\": 3053 }, { \"title\": \"Postgres\", \"id\": 105, \"created\": 1437522726931, \"updated\": 1438194844405, \"subTitle\": \"Database\", \"description\": \"PostgreSQL, often simply Postgres, is an object-relational database...\" } ] }, { \"row\": [ { \"title\": \"Heroku\", \"id\": 107, \"created\": 1437522726931, \"updated\": 1438195289879, \"subTitle\": \"Platform as a Service\", \"description\": \"Heroku is a cloud platform as a service (PaaS)...\" }, { \"title\": \"herokuHosting\", \"id\": 305, \"created\": 1437522726931, \"updated\": 1437522726931 }, { \"title\": \"Hosting\", \"id\": 202, \"created\": 1437522726931, \"updated\": 1437522726931, \"subTitle\": \"Capability\", \"description\": \"HostingDescription\" }, { \"id\": 3054 }, { \"title\": \"Elixir\", \"id\": 104, \"created\": 1437522726931, \"updated\": 1438197525156, \"subTitle\": \"Programming Langugage\", \"description\": \"Elixir is a functional, concurrent, general-purpose programming language...\" } ] } ], \"stats\": { \"contains_updates\": false, \"nodes_created\": 0, \"nodes_deleted\": 0, \"properties_set\": 0, \"relationships_created\": 0, \"relationship_deleted\": 0, \"labels_added\": 0, \"labels_removed\": 0, \"indexes_added\": 0, \"indexes_removed\": 0, \"constraints_added\": 0, \"constraints_removed\": 0 }}"
    input = Poison.decode!(json)
    expected = %{tools: [
        %{title: "Heroku", id: 107, created: "2015-07-21T23:52:06.931Z", updated: "2015-07-29T18:41:29.879Z", subTitle: "Platform as a Service", description: "Heroku is a cloud platform as a service (PaaS)...", features: [305]},
        %{id: 104, title: "Elixir", subTitle: "Programming Langugage", updated: "2015-07-29T19:18:45.156Z", created: "2015-07-21T23:52:06.931Z", description: "Elixir is a functional, concurrent, general-purpose programming language...", features: [302]},
        %{id: 101, title: "Java", subTitle: "Programming Language", updated: "2015-07-29T18:38:34.593Z", created: "2015-07-21T23:52:06.931Z", description: "Java is a general-purpose computer programming language...", features: []}],
      features: [
        %{ title: "herokuHosting", id: 305, created: "2015-07-21T23:52:06.931Z", updated: "2015-07-21T23:52:06.931Z", capability: 202, supports: [3053, 3054]},
        %{ title: "ecto", id: 302, created: "2015-07-21T23:52:06.931Z", updated: "2015-07-21T23:52:06.931Z", capability: 204, supports: [3024,3023]}],
      capability: [
        %{ title: "Hosting", id: 202, created: "2015-07-21T23:52:06.931Z", updated: "2015-07-21T23:52:06.931Z", subTitle: "Capability", description: "HostingDescription"},
        %{ title: "Connecting", id: 204, created: "2015-07-21T23:52:06.931Z", updated: "2015-07-21T23:52:06.931Z", subTitle: "Capability", description: "ConnectingDescription" }],
      supports: [
        %{id: 3053, feature: 305, concept: 105},
        %{id: 3054, feature: 305, concept: 104},
        %{id: 3024, feature: 302, concept: 106},
        %{id: 3023, feature: 302, concept: 105}]
    }
    actual = Mapper.map_entities(Tool, input["data"], input["columns"])
    assert expected[:tools] === actual[:tools]
    assert expected[:features] === actual[:features]
    assert expected[:capability] === actual[:capability]
    assert expected[:supports] === actual[:supports]
    assert expected[:tools] === actual[:tools]
  end

  test "map one tool two rows" do
    json1 = @json_one_tool_first_row
    json2 = @json_one_tool_second_row
    row1 = Poison.decode!(json1)
    row2 = Poison.decode!(json2)
    expected = %{ tool: %{id: 104, title: "Elixir", subTitle: "Programming Langugage", updated: "2015-07-29T19:18:45.156Z", created: "2015-07-21T23:52:06.931Z", description: "Elixir is a functional...", features: [302]},
      features: [%{id: 302, title: "ecto", updated: "2015-07-21T23:52:06.931Z", created: "2015-07-21T23:52:06.931Z", capability: 204, supports: [3023,3024]}],
      capability: [%{id: 204, title: "Connecting", updated: "2015-07-21T23:52:06.931Z", created: "2015-07-21T23:52:06.931Z", subTitle: "Capability", description: "ConnectingDescription"}],
      supports: [%{id: 3023, feature: 302, concept: 105},%{id: 3024, feature: 302, concept: 106}],
      tools: [%{title: "Postgres", id: 105, created: "2015-07-21T23:52:06.931Z", updated: "2015-07-29T18:34:04.405Z", subTitle: "Database", description: "PostgreSQL, often simply Postgres..." },
        %{id: 106, title: "MySQL", created: "2015-07-21T23:52:06.931Z", updated: "2015-07-29T18:40:41.244Z", subTitle: "Database", description: "MySQL (/maɪ ˌɛskjuːˈɛl/ 'My S-Q-L',[6] officially..."}]
    }
    actual = Mapper.map_single_entity(Tool, [row1, row2], @columns)
    assert expected[:tool] === actual[:tool]
    assert expected[:features] === actual[:features]
    assert expected[:capability] === actual[:capability]
    assert expected[:supports] === actual[:supports]
    assert expected[:tools] === actual[:tools]
  end

  test "map one tool one row" do
    json = @json_one_tool_first_row
    row = Poison.decode!(json)
    expected = %{ tool: %{id: 104, title: "Elixir", subTitle: "Programming Langugage", updated: "2015-07-29T19:18:45.156Z", created: "2015-07-21T23:52:06.931Z", description: "Elixir is a functional...", features: [302]},
      feature: %{id: 302, title: "ecto", updated: "2015-07-21T23:52:06.931Z", created: "2015-07-21T23:52:06.931Z", capability: 204, supports: [3024]},
      capability: %{id: 204, title: "Connecting", updated: "2015-07-21T23:52:06.931Z", created: "2015-07-21T23:52:06.931Z", subTitle: "Capability", description: "ConnectingDescription"},
      supports: %{id: 3024, feature: 302, concept: 106},
      concept: %{id: 106, title: "MySQL", created: "2015-07-21T23:52:06.931Z", updated: "2015-07-29T18:40:41.244Z", subTitle: "Database", description: "MySQL (/maɪ ˌɛskjuːˈɛl/ 'My S-Q-L',[6] officially..."}
    }
    actual = Mapper.map_one_row(Tool, row, @columns)
    # assert_equal_except(expected, actual)
    # AssertMore.assert_equal_except(expected, actual)
    assert expected[:tool] === actual[:tool]
    assert expected[:feature] === actual[:feature]
    assert expected[:capability] === actual[:capability]
    assert expected[:supports] === actual[:supports]
    assert expected[:concept] === actual[:concept]
  end

  test "map single entity with no features" do
    json = @json_row_one_tool_no_features
    row = Poison.decode!(json)
    expected = %{ tool: %{id: 101, title: "Java", subTitle: "Programming Language", updated: "2015-07-29T18:38:34.593Z", created: "2015-07-21T23:52:06.931Z", description: "Java is a general-purpose computer programming language...", features: []},
      features: [], supports: [], capability: [], tools: []}
    actual = Mapper.map_single_entity(Tool, [row], @columns)
    assert_equal_except(expected, actual)
    assert expected === actual
  end

  test "map one tool row with no features" do
    json = @json_row_one_tool_no_features
    row = Poison.decode!(json)
    expected = %{ tool: %{id: 101, title: "Java", subTitle: "Programming Language", updated: "2015-07-29T18:38:34.593Z", created: "2015-07-21T23:52:06.931Z", description: "Java is a general-purpose computer programming language...", features: []}}
    actual = Mapper.map_one_row(Tool, row, @columns)
    assert_equal_except(expected, actual)
    assert expected === actual
  end

  test "unify entities" do
    entities = [%{created: 1437522726931, id: 302, capability: 203, supports: [3023],
      title: "ecto", updated: 1437522726931},
      %{created: 1437522726931, id: 302, capability: 203, supports: [3024],
      title: "ecto", updated: 1437522726931}]
    expected = [%{created: 1437522726931, id: 302, capability: 203, supports: [3023, 3024],
              title: "ecto", updated: 1437522726931}]
    actual = Mapper.unify_entity(entities, [:supports])
    assert expected === actual
  end
  
end