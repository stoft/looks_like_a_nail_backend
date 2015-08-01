defmodule LooksLikeANailBackend.ToolTest do
  use ExUnit.Case, async: true

  alias LooksLikeANailBackend.Tool
  # doctest LooksLikeANailBackend.Tool

  test "get create statement" do
    statement = "CREATE (tool:Tool {title: \"Foo\"}) SET tool.id = id(tool), tool.updated = timestamp(), tool.created = timestamp() RETURN tool"
    assert statement == Tool.get_create_statement(%{title: "Foo"})
  end

  # test "map neo response row to Tool" do
  #   json = "{\"row\":[{\"title\":\"Heroku\",\"id\":107,\"subTitle\":\"Platform as a Service\",\"description\":\"HerokuDescription\",\"created\":1437683566287,\"updated\":1437683566287},{\"id\":3055},{\"title\":\"herokuBuilding\",\"id\":306,\"created\":1437683566287,\"updated\":1437683566287},{\"id\":3056},{\"title\":\"Building\",\"id\":201,\"subTitle\":\"Task\",\"description\":\"BuildingDescription\",\"created\":1437683566287,\"updated\":1437683566287},{\"id\":3057},{\"title\":\"Elixir\",\"id\":104,\"subTitle\":\"Programming Language\",\"description\":\"Elixir is a functional, concurrent, general-purpose programming language that runs on the Erlang virtual machine (BEAM). Elixir builds on top of Erlang to provide distributed, fault-tolerant, soft real-time, non-stop applications but also extends it to support metaprogramming with macros and polymorphism via protocols.\",\"created\":1437683566287,\"updated\":1437683566420}]}"
  #   response_row = Poison.decode! json
  #   expected = %{:tool => %{:title => "Heroku",:id => 107,:subTitle => "Platform as a Service",:description => "HerokuDescription", :implements => [306], :created => 1437683566287,:updated => 1437683566287},
  #     :implements => [%{:id => 3055, :feature => 306, :tool => 107}],
  #     :features => [%{:title => "herokuBuilding", :id => 306, :created => 1437683566287, :updated => 1437683566287, :isCapableOf => [201]}],
  #     :isCapableOf => [%{:id => 3056, :feature => 306, :task => 201}],
  #     :tasks => [%{:title => "Building", :id => 201, :subTitle => "Task", :description => "BuildingDescription", :created => 1437683566287, :updated => 1437683566287}]
  #   }
  #   actual = Tool.map_row_from_neo(response_row)
  #   assert expected === actual
  # end

  # test "map neo response to Tool" do
  #   json = "{\"columns\":[\"tool\",\"implements\",\"feature\",\"isCapableOf\",\"task\",\"supports\",\"otherTool\"],\"data\":[{\"row\":[{\"title\":\"Heroku\",\"id\":107,\"subTitle\":\"Platform as a Service\",\"description\":\"HerokuDescription\",\"created\":1437683566287,\"updated\":1437683566287},{\"id\":3055},{\"title\":\"herokuBuilding\",\"id\":306,\"created\":1437683566287,\"updated\":1437683566287},{\"id\":3056},{\"title\":\"Building\",\"id\":201,\"subTitle\":\"Task\",\"description\":\"BuildingDescription\",\"created\":1437683566287,\"updated\":1437683566287},{\"id\":3057},{\"title\":\"Elixir\",\"id\":104,\"subTitle\":\"Programming Language\",\"description\":\"Elixir is a functional, concurrent, general-purpose programming language that runs on the Erlang virtual machine (BEAM). Elixir builds on top of Erlang to provide distributed, fault-tolerant, soft real-time, non-stop applications but also extends it to support metaprogramming with macros and polymorphism via protocols.\",\"created\":1437683566287,\"updated\":1437683566420}],\"graph\":{\"nodes\":[{\"id\":\"174\",\"labels\":[\"Tool\"],\"properties\":{\"title\":\"Elixir\",\"id\":104,\"subTitle\":\"Programming Language\",\"description\":\"Elixir is a functional, concurrent, general-purpose programming language that runs on the Erlang virtual machine (BEAM). Elixir builds on top of Erlang to provide distributed, fault-tolerant, soft real-time, non-stop applications but also extends it to support metaprogramming with macros and polymorphism via protocols.\",\"created\":1437683566287,\"updated\":1437683566420}},{\"id\":\"188\",\"labels\":[\"Feature\"],\"properties\":{\"title\":\"herokuBuilding\",\"id\":306,\"created\":1437683566287,\"updated\":1437683566287}},{\"id\":\"178\",\"labels\":[\"Task\"],\"properties\":{\"title\":\"Building\",\"id\":201,\"subTitle\":\"Task\",\"description\":\"BuildingDescription\",\"created\":1437683566287,\"updated\":1437683566287}},{\"id\":\"177\",\"labels\":[\"Tool\"],\"properties\":{\"title\":\"Heroku\",\"id\":107,\"subTitle\":\"Platform as a Service\",\"description\":\"HerokuDescription\",\"created\":1437683566287,\"updated\":1437683566287}}],\"relationships\":[{\"id\":\"178\",\"type\":\"IS_CAPABLE_OF\",\"startNode\":\"188\",\"endNode\":\"178\",\"properties\":{\"id\":3056}},{\"id\":\"179\",\"type\":\"SUPPORTS\",\"startNode\":\"188\",\"endNode\":\"174\",\"properties\":{\"id\":3057}},{\"id\":\"177\",\"type\":\"IMPLEMENTS\",\"startNode\":\"177\",\"endNode\":\"188\",\"properties\":{\"id\":3055}}]}},{\"row\":[{\"title\":\"Heroku\",\"id\":107,\"subTitle\":\"Platform as a Service\",\"description\":\"HerokuDescription\",\"created\":1437683566287,\"updated\":1437683566287},{\"id\":3051},{\"title\":\"herokuHosting\",\"id\":305,\"created\":1437683566287,\"updated\":1437683566287},{\"id\":3052},{\"title\":\"Hosting\",\"id\":202,\"subTitle\":\"Task\",\"description\":\"HostingDescription\",\"created\":1437683566287,\"updated\":1437683566287},{\"id\":3054},{\"title\":\"Elixir\",\"id\":104,\"subTitle\":\"Programming Language\",\"description\":\"Elixir is a functional, concurrent, general-purpose programming language that runs on the Erlang virtual machine (BEAM). Elixir builds on top of Erlang to provide distributed, fault-tolerant, soft real-time, non-stop applications but also extends it to support metaprogramming with macros and polymorphism via protocols.\",\"created\":1437683566287,\"updated\":1437683566420}],\"graph\":{\"nodes\":[{\"id\":\"187\",\"labels\":[\"Feature\"],\"properties\":{\"title\":\"herokuHosting\",\"id\":305,\"created\":1437683566287,\"updated\":1437683566287}},{\"id\":\"174\",\"labels\":[\"Tool\"],\"properties\":{\"title\":\"Elixir\",\"id\":104,\"subTitle\":\"Programming Language\",\"description\":\"Elixir is a functional, concurrent, general-purpose programming language that runs on the Erlang virtual machine (BEAM). Elixir builds on top of Erlang to provide distributed, fault-tolerant, soft real-time, non-stop applications but also extends it to support metaprogramming with macros and polymorphism via protocols.\",\"created\":1437683566287,\"updated\":1437683566420}},{\"id\":\"179\",\"labels\":[\"Task\"],\"properties\":{\"title\":\"Hosting\",\"id\":202,\"subTitle\":\"Task\",\"description\":\"HostingDescription\",\"created\":1437683566287,\"updated\":1437683566287}},{\"id\":\"177\",\"labels\":[\"Tool\"],\"properties\":{\"title\":\"Heroku\",\"id\":107,\"subTitle\":\"Platform as a Service\",\"description\":\"HerokuDescription\",\"created\":1437683566287,\"updated\":1437683566287}}],\"relationships\":[{\"id\":\"174\",\"type\":\"IS_CAPABLE_OF\",\"startNode\":\"187\",\"endNode\":\"179\",\"properties\":{\"id\":3052}},{\"id\":\"173\",\"type\":\"IMPLEMENTS\",\"startNode\":\"177\",\"endNode\":\"187\",\"properties\":{\"id\":3051}},{\"id\":\"176\",\"type\":\"SUPPORTS\",\"startNode\":\"187\",\"endNode\":\"174\",\"properties\":{\"id\":3054}}]}},{\"row\":[{\"title\":\"Heroku\",\"id\":107,\"subTitle\":\"Platform as a Service\",\"description\":\"HerokuDescription\",\"created\":1437683566287,\"updated\":1437683566287},{\"id\":3051},{\"title\":\"herokuHosting\",\"id\":305,\"created\":1437683566287,\"updated\":1437683566287},{\"id\":3052},{\"title\":\"Hosting\",\"id\":202,\"subTitle\":\"Task\",\"description\":\"HostingDescription\",\"created\":1437683566287,\"updated\":1437683566287},{\"id\":3053},{\"title\":\"Postgres\",\"id\":105,\"subTitle\":\"Database\",\"description\":\"PostgresDescription\",\"created\":1437683566287,\"updated\":1437683566287}],\"graph\":{\"nodes\":[{\"id\":\"187\",\"labels\":[\"Feature\"],\"properties\":{\"title\":\"herokuHosting\",\"id\":305,\"created\":1437683566287,\"updated\":1437683566287}},{\"id\":\"175\",\"labels\":[\"Tool\"],\"properties\":{\"title\":\"Postgres\",\"id\":105,\"subTitle\":\"Database\",\"description\":\"PostgresDescription\",\"created\":1437683566287,\"updated\":1437683566287}},{\"id\":\"179\",\"labels\":[\"Task\"],\"properties\":{\"title\":\"Hosting\",\"id\":202,\"subTitle\":\"Task\",\"description\":\"HostingDescription\",\"created\":1437683566287,\"updated\":1437683566287}},{\"id\":\"177\",\"labels\":[\"Tool\"],\"properties\":{\"title\":\"Heroku\",\"id\":107,\"subTitle\":\"Platform as a Service\",\"description\":\"HerokuDescription\",\"created\":1437683566287,\"updated\":1437683566287}}],\"relationships\":[{\"id\":\"175\",\"type\":\"SUPPORTS\",\"startNode\":\"187\",\"endNode\":\"175\",\"properties\":{\"id\":3053}},{\"id\":\"174\",\"type\":\"IS_CAPABLE_OF\",\"startNode\":\"187\",\"endNode\":\"179\",\"properties\":{\"id\":3052}},{\"id\":\"173\",\"type\":\"IMPLEMENTS\",\"startNode\":\"177\",\"endNode\":\"187\",\"properties\":{\"id\":3051}}]}}],\"stats\":{\"contains_updates\":false,\"nodes_created\":0,\"nodes_deleted\":0,\"properties_set\":0,\"relationships_created\":0,\"relationship_deleted\":0,\"labels_added\":0,\"labels_removed\":0,\"indexes_added\":0,\"indexes_removed\":0,\"constraints_added\":0,\"constraints_removed\":0}}"
  #   response = Poison.decode!(json)
  #   expected = %{:tool => %{:title => "Heroku", :id => 107, :subTitle => "Platform as a Service", :description => "HerokuDescription", :implements => [306, 305], :created => 1437683566287, :updated => 1437683566287},
  #     :implements => [
  #       %{:id => 3055, :feature => 306, :tool => 107},
  #       %{:id => 3051, :feature => 305, :tool => 107}
  #       ],
  #     :features => [
  #       %{:title => "herokuBuilding", :id => 306, :created => 1437683566287, :updated => 1437683566287, :isCapableOf => [201]},
  #       %{:title => "herokuHosting",
  #             :id => 305,
  #             :isCapableOf => [202],
  #             :created => 1437683566287,
  #             :updated => 1437683566287}
  #       ],
  #     :isCapableOf => [
  #       %{:id => 3056, :feature => 306, :task => 201},
  #       %{:id => 3052, :feature => 305, :task => 202}
  #     ],
  #     :tasks => [
  #       %{:title => "Building", :id => 201, :subTitle => "Task", :description => "BuildingDescription", :created => 1437683566287, :updated => 1437683566287},
  #       %{:title => "Hosting",
  #             :id => 202,
  #             :subTitle => "Task",
  #             :description => "HostingDescription",
  #             :created => 1437683566287,
  #             :updated => 1437683566287}
  #     ]
  #   }
  #   actual = Tool.map_get_from_neo(response)
  #   assert expected === actual
  # end
end