defmodule AssertMore do
  @moduledoc """
  More assert functions.
  """

  import ExUnit.Assertions, only: [assert: 1, assert: 2]
  
  @doc """
  Asserts that two data structures are equal, except certain keys.
  The data structures can be nested, such as maps with lists with maps.
  The location of the excepted keys in the structure doesn't matter.

  Supports lists, keyword lists, dicts and all basic terms.

  Uses Enum.map/2, Enum.member?/2, Dict.get/2 and ExUnit's 
  `assert expected === actual`.

  iex> AssertMore.assert_equals_except([a: 1, b:2], [a: 1, b:3], [:b])
  true
  """
  @spec assert_equals_except(any, any, list) :: boolean
  def assert_equals_except(expected, actual, keys \\ [])
  
  def assert_equals_except(%{} = expected, %{} = actual, keys) do
    Enum.map(expected, fn({k,v})->
      except_or_assert(k, v, actual, keys)
    end)
  end
  
  def assert_equals_except({ek, ev}, {ak, av}, keys) do
    except_or_assert(ek, ev, [{ak, av}], keys)
  end

  def assert_equals_except([he|expected], [ha|actual], keys) do
    assert_equals_except(he, ha, keys)
    assert_equals_except(expected, actual, keys)
  end

  def assert_equals_except(expected, actual, keys) do
    assert expected === actual
  end

  defp except_or_assert(k, v, actual, keys) do
    if Enum.member?(keys, k) do
      true
    else
      assert_equals_except v, Dict.get(actual, k), keys
    end
  end
end