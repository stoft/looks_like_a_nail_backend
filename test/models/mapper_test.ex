defmodule LooksLikeANailBackend.MapperTest do
  use ExUnit.Case, async: true

  alias LooksLikeANailBackend.Mapper
  alias LooksLikeANailBackend.Tool

  @json_one_tool_first_row "{ \"row\": [ { \"title\": \"Elixir\", \"id\": 104, \"created\": 1437522726931, \"updated\": 1438197525156, \"subTitle\": \"Programming Langugage\", \"description\": \"Elixir is a functional...\" }, { \"id\": 3021 }, { \"title\": \"ecto\", \"id\": 302, \"created\": 1437522726931, \"updated\": 1437522726931 }, { \"id\": 3022 }, { \"title\": \"Connecting\", \"id\": 204, \"created\": 1437522726931, \"updated\": 1437522726931, \"subTitle\": \"Task\", \"description\": \"ConnectingDescription\" }, { \"id\": 3024 }, { \"title\": \"MySQL\", \"id\": 106, \"created\": 1437522726931, \"updated\": 1438195241244, \"subTitle\": \"Database\", \"description\": \"MySQL (/maɪ ˌɛskjuːˈɛl/ 'My S-Q-L',[6] officially...\" } ] }"
  @json_one_tool_second_row "{\"row\": [ { \"title\": \"Elixir\", \"id\": 104, \"created\": 1437522726931, \"updated\": 1438197525156, \"subTitle\": \"Programming Langugage\", \"description\": \"Elixir is a functional...\" }, { \"id\": 3021 }, { \"title\": \"ecto\", \"id\": 302, \"created\": 1437522726931, \"updated\": 1437522726931 }, { \"id\": 3022 }, { \"title\": \"Connecting\", \"id\": 204, \"created\": 1437522726931, \"updated\": 1437522726931, \"subTitle\": \"Task\", \"description\": \"ConnectingDescription\" }, { \"id\": 3023 }, { \"title\": \"Postgres\", \"id\": 105, \"created\": 1437522726931, \"updated\": 1438194844405, \"subTitle\": \"Database\", \"description\": \"PostgreSQL, often simply Postgres...\" } ]}"

  @json_implements1 "{\"id\": \"605\", \"type\": \"IMPLEMENTS\",
        \"startNode\": \"639\", \"endNode\": \"649\", \"properties\": {\"id\": 3051}}"

  @json_implements2 "{\"id\": \"606\",\"type\": \"IMPLEMENTS\",
        \"startNode\": \"639\", \"endNode\": \"650\", \"properties\": {\"id\": 3055}}"

  @json_provides "{\"id\": \"606\", \"type\": \"PROVIDES\",
        \"startNode\": \"649\", \"endNode\": \"641\", \"properties\": {\"id\": 3052}}"

  @json_feature "{\"id\": \"649\",\"labels\": [\"Feature\"],
        \"properties\": {\"title\": \"herokuHosting\",
        \"id\": 305, \"created\": 1437522726931,\"updated\": 1437522726931}}"

  @json_task "{\"id\": \"641\", \"labels\": [\"Task\"],
        \"properties\": {\"title\": \"Hosting\", \"id\": 202, \"created\": 1437522726931,
        \"updated\": 1437522726931, \"subTitle\": \"Task\",
        \"description\": \"HostingDescription\"}}"

  @json_row_one_tool_no_features "{ \"row\": [ { \"title\": \"Java\", \"id\": 101, \"created\": 1437522726931, \"updated\": 1438195114593, \"subTitle\": \"Programming Language\", \"description\": \"Java is a general-purpose computer programming language...\" }, null, null, null, null, null, null ] }"
  
  @columns ["tool","implements","feature","provides","task","supports","otherTool"]

  test "map tools" do
    json = "{ \"columns\": [ \"tool\", \"implements\", \"feature\", \"provides\", \"task\", \"supports\", \"otherTool\" ], \"data\": [ { \"row\": [ { \"title\": \"Java\", \"id\": 101, \"created\": 1437522726931, \"updated\": 1438195114593, \"subTitle\": \"Programming Language\", \"description\": \"Java is a general-purpose computer programming language...\" }, null, null, null, null, null, null ] }, { \"row\": [ { \"title\": \"Elixir\", \"id\": 104, \"created\": 1437522726931, \"updated\": 1438197525156, \"subTitle\": \"Programming Langugage\", \"description\": \"Elixir is a functional, concurrent, general-purpose programming language...\" }, { \"id\": 3021 }, { \"title\": \"ecto\", \"id\": 302, \"created\": 1437522726931, \"updated\": 1437522726931 }, { \"id\": 3022 }, { \"title\": \"Connecting\", \"id\": 204, \"created\": 1437522726931, \"updated\": 1437522726931, \"subTitle\": \"Task\", \"description\": \"ConnectingDescription\" }, { \"id\": 3024 }, { \"title\": \"MySQL\", \"id\": 106, \"created\": 1437522726931, \"updated\": 1438195241244, \"subTitle\": \"Database\", \"description\": \"MySQL (/maɪ ˌɛskjuːˈɛl/ 'My S-Q-L',[6] officially...\" } ] }, { \"row\": [ { \"title\": \"Elixir\", \"id\": 104, \"created\": 1437522726931, \"updated\": 1438197525156, \"subTitle\": \"Programming Langugage\", \"description\": \"Elixir is a functional, concurrent, general-purpose programming language...\" }, { \"id\": 3021 }, { \"title\": \"ecto\", \"id\": 302, \"created\": 1437522726931, \"updated\": 1437522726931 }, { \"id\": 3022 }, { \"title\": \"Connecting\", \"id\": 204, \"created\": 1437522726931, \"updated\": 1437522726931, \"subTitle\": \"Task\", \"description\": \"ConnectingDescription\" }, { \"id\": 3023 }, { \"title\": \"Postgres\", \"id\": 105, \"created\": 1437522726931, \"updated\": 1438194844405, \"subTitle\": \"Database\", \"description\": \"PostgreSQL, often simply Postgres, is an object-relational database...\" } ] }, { \"row\": [ { \"title\": \"Heroku\", \"id\": 107, \"created\": 1437522726931, \"updated\": 1438195289879, \"subTitle\": \"Platform as a Service\", \"description\": \"Heroku is a cloud platform as a service (PaaS)...\" }, { \"id\": 3051 }, { \"title\": \"herokuHosting\", \"id\": 305, \"created\": 1437522726931, \"updated\": 1437522726931 }, { \"id\": 3052 }, { \"title\": \"Hosting\", \"id\": 202, \"created\": 1437522726931, \"updated\": 1437522726931, \"subTitle\": \"Task\", \"description\": \"HostingDescription\" }, { \"id\": 3053 }, { \"title\": \"Postgres\", \"id\": 105, \"created\": 1437522726931, \"updated\": 1438194844405, \"subTitle\": \"Database\", \"description\": \"PostgreSQL, often simply Postgres, is an object-relational database...\" } ] }, { \"row\": [ { \"title\": \"Heroku\", \"id\": 107, \"created\": 1437522726931, \"updated\": 1438195289879, \"subTitle\": \"Platform as a Service\", \"description\": \"Heroku is a cloud platform as a service (PaaS)...\" }, { \"id\": 3051 }, { \"title\": \"herokuHosting\", \"id\": 305, \"created\": 1437522726931, \"updated\": 1437522726931 }, { \"id\": 3052 }, { \"title\": \"Hosting\", \"id\": 202, \"created\": 1437522726931, \"updated\": 1437522726931, \"subTitle\": \"Task\", \"description\": \"HostingDescription\" }, { \"id\": 3054 }, { \"title\": \"Elixir\", \"id\": 104, \"created\": 1437522726931, \"updated\": 1438197525156, \"subTitle\": \"Programming Langugage\", \"description\": \"Elixir is a functional, concurrent, general-purpose programming language...\" } ] } ], \"stats\": { \"contains_updates\": false, \"nodes_created\": 0, \"nodes_deleted\": 0, \"properties_set\": 0, \"relationships_created\": 0, \"relationship_deleted\": 0, \"labels_added\": 0, \"labels_removed\": 0, \"indexes_added\": 0, \"indexes_removed\": 0, \"constraints_added\": 0, \"constraints_removed\": 0 }}"
    input = Poison.decode!(json)
    expected = %{tools: [
        %{title: "Heroku", id: 107, created: "2015-07-21T23:52:06.931Z", updated: "2015-07-29T18:41:29.879Z", subTitle: "Platform as a Service", description: "Heroku is a cloud platform as a service (PaaS)...", implements: [3051]},
        %{id: 104, title: "Elixir", subTitle: "Programming Langugage", updated: "2015-07-29T19:18:45.156Z", created: "2015-07-21T23:52:06.931Z", description: "Elixir is a functional, concurrent, general-purpose programming language...", implements: [3021]},
        %{id: 101, title: "Java", subTitle: "Programming Language", updated: "2015-07-29T18:38:34.593Z", created: "2015-07-21T23:52:06.931Z", description: "Java is a general-purpose computer programming language...", implements: []}],
      implements: [
        %{id: 3051, feature: 305, tool: 107},
        %{id: 3021, feature: 302, tool: 104}],
      features: [
        %{ title: "herokuHosting", id: 305, created: "2015-07-21T23:52:06.931Z", updated: "2015-07-21T23:52:06.931Z", provides: [3052], supports: [3053, 3054]},
        %{ title: "ecto", id: 302, created: "2015-07-21T23:52:06.931Z", updated: "2015-07-21T23:52:06.931Z", provides: [3022], supports: [3024,3023]}],
      provides: [
        %{id: 3052, feature: 305, task: 202},
        %{id: 3022, feature: 302, task: 204}],
      tasks: [
        %{ title: "Hosting", id: 202, created: "2015-07-21T23:52:06.931Z", updated: "2015-07-21T23:52:06.931Z", subTitle: "Task", description: "HostingDescription"},
        %{ title: "Connecting", id: 204, created: "2015-07-21T23:52:06.931Z", updated: "2015-07-21T23:52:06.931Z", subTitle: "Task", description: "ConnectingDescription" }],
      supports: [
        %{id: 3053, feature: 305, tool: 105},
        %{id: 3054, feature: 305, tool: 104},
        %{id: 3024, feature: 302, tool: 106},
        %{id: 3023, feature: 302, tool: 105}]
    }
    actual = Mapper.map_entities(Tool, input["data"], input["columns"])
    assert expected[:tools] === actual[:tools]
    assert expected[:implements] === actual[:implements]
    assert expected[:features] === actual[:features]
    assert expected[:provides] === actual[:provides]
    assert expected[:tasks] === actual[:tasks]
    assert expected[:supports] === actual[:supports]
    assert expected[:tools] === actual[:tools]
  end

  test "map one tool two rows" do
    json1 = @json_one_tool_first_row
    json2 = @json_one_tool_second_row
    row1 = Poison.decode!(json1)
    row2 = Poison.decode!(json2)
    expected = %{ tool: %{id: 104, title: "Elixir", subTitle: "Programming Langugage", updated: "2015-07-29T19:18:45.156Z", created: "2015-07-21T23:52:06.931Z", description: "Elixir is a functional...", implements: [3021]},
      features: [%{id: 302, title: "ecto", updated: "2015-07-21T23:52:06.931Z", created: "2015-07-21T23:52:06.931Z", provides: [3022], supports: [3023,3024]}],
      tasks: [%{id: 204, title: "Connecting", updated: "2015-07-21T23:52:06.931Z", created: "2015-07-21T23:52:06.931Z", subTitle: "Task", description: "ConnectingDescription"}],
      implements: [%{id: 3021, tool: 104, feature: 302}],
      provides: [%{id: 3022, task: 204, feature: 302}],
      supports: [%{id: 3023, feature: 302, tool: 105},%{id: 3024, feature: 302, tool: 106}],
      tools: [%{title: "Postgres", id: 105, created: "2015-07-21T23:52:06.931Z", updated: "2015-07-29T18:34:04.405Z", subTitle: "Database", description: "PostgreSQL, often simply Postgres..." },
        %{id: 106, title: "MySQL", created: "2015-07-21T23:52:06.931Z", updated: "2015-07-29T18:40:41.244Z", subTitle: "Database", description: "MySQL (/maɪ ˌɛskjuːˈɛl/ 'My S-Q-L',[6] officially..."}]
    }
    actual = Mapper.map_single_entity(Tool, [row1, row2], @columns)
    assert expected[:tool] === actual[:tool]
    assert expected[:implements] === actual[:implements]
    assert expected[:features] === actual[:features]
    assert expected[:provides] === actual[:provides]
    assert expected[:tasks] === actual[:tasks]
    assert expected[:supports] === actual[:supports]
    assert expected[:tools] === actual[:tools]
  end

  test "map one tool one row" do
    json = @json_one_tool_first_row
    row = Poison.decode!(json)
    expected = %{ tool: %{id: 104, title: "Elixir", subTitle: "Programming Langugage", updated: "2015-07-29T19:18:45.156Z", created: "2015-07-21T23:52:06.931Z", description: "Elixir is a functional...", implements: [3021]},
      feature: %{id: 302, title: "ecto", updated: "2015-07-21T23:52:06.931Z", created: "2015-07-21T23:52:06.931Z", provides: [3022], supports: [3024]},
      task: %{id: 204, title: "Connecting", updated: "2015-07-21T23:52:06.931Z", created: "2015-07-21T23:52:06.931Z", subTitle: "Task", description: "ConnectingDescription"},
      implements: %{id: 3021, tool: 104, feature: 302},
      provides: %{id: 3022, task: 204, feature: 302},
      supports: %{id: 3024, feature: 302, tool: 106},
      otherTool: %{id: 106, title: "MySQL", created: "2015-07-21T23:52:06.931Z", updated: "2015-07-29T18:40:41.244Z", subTitle: "Database", description: "MySQL (/maɪ ˌɛskjuːˈɛl/ 'My S-Q-L',[6] officially..."}
    }
    actual = Mapper.map_one_row(Tool, row, @columns)
    assert expected === actual
  end

  test "map single entity with no features" do
    json = @json_row_one_tool_no_features
    row = Poison.decode!(json)
    expected = %{ tool: %{id: 101, title: "Java", subTitle: "Programming Language", updated: "2015-07-29T18:38:34.593Z", created: "2015-07-21T23:52:06.931Z", description: "Java is a general-purpose computer programming language...", implements: []},
      features: [], implements: [], provides: [], supports: [], tasks: [], tools: []}
    actual = Mapper.map_single_entity(Tool, [row], @columns)
    assert expected === actual
  end

  test "map one tool row with no features" do
    json = @json_row_one_tool_no_features
    row = Poison.decode!(json)
    expected = %{ tool: %{id: 101, title: "Java", subTitle: "Programming Language", updated: "2015-07-29T18:38:34.593Z", created: "2015-07-21T23:52:06.931Z", description: "Java is a general-purpose computer programming language...", implements: []}}
    actual = Mapper.map_one_row(Tool, row, @columns)
    assert expected === actual
  end

  test "unify entities" do
    entities = [%{created: 1437522726931, id: 302, provides: [3022], supports: [3023],
      title: "ecto", updated: 1437522726931},
      %{created: 1437522726931, id: 302, provides: [3022], supports: [3024],
      title: "ecto", updated: 1437522726931}]
    expected = [%{created: 1437522726931, id: 302, provides: [3022], supports: [3023, 3024],
              title: "ecto", updated: 1437522726931}]
    actual = Mapper.unify_entity(entities, [:provides, :supports])
    assert expected === actual
  end
  
end