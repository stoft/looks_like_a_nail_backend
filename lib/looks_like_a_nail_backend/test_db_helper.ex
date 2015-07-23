defmodule LooksLikeANailBackend.TestDBHelper do

  def setup_db() do
    statement = File.read!(Path.expand("~/Projects/js/lookslikeanail-frontend/tests/testdata.cql"))
    Neo4J.Repo.do_cypher_statements! [statement]
  end

end