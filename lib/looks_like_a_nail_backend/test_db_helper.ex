defmodule LooksLikeANailBackend.TestDBHelper do

  def setup_db(:tool_feature_task) do
    statement = File.read!(Path.expand("~/Projects/js/lookslikeanail-frontend/tests/testdata.cql"))
    Neo4J.Repo.do_cypher_statements! [statement]
  end
    
end