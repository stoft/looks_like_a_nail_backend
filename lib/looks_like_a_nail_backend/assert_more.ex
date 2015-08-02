defmodule AssertMore do
  @moduledoc """
  More assert functions.
  """

  import ExUnit.Assertions, only: [assert: 1, assert: 2]

  @doc """
  Assserts that two data structures match, except certain keys.
  Same functionality as `assert_equal_except/3` but uses `===`.
  """
  @spec assert_match_except(any, any, list) :: boolean
  def assert_match_except(expected, actual, keys \\ []) do
    assert_except(expected, actual, keys, :match)
  end

  @doc """
  Asserts that two data structures are equal (==), except certain keys.
  The data structures can be nested, such as maps with lists with maps.
  The location of the excepted keys in the structure doesn't matter.

  Supports lists, keyword lists, dicts and all basic terms.

  Uses Enum.map/2, Enum.member?/2, Dict.get/2 and ExUnit's 
  `assert expected == actual`.

  iex> AssertMore.assert_equal_except([a: 1, b:2], [a: 1, b:3], [:b])
  true
  """
  @spec assert_equal_except(any, any, list) :: boolean
  def assert_equal_except(expected, actual, keys \\ []) do
    assert_except(expected, actual, keys, :equal)
  end
  
  defp assert_except(%{} = expected, %{} = actual, keys, operator) do
    Enum.map(expected, fn({k,v})->
      except_or_assert(k, v, actual, keys, operator)
    end)
  end
  
  defp assert_except({ek, ev}, {ak, av}, keys, operator) do
    except_or_assert(ek, ev, [{ak, av}], keys, operator)
  end

  defp assert_except([he|expected], [ha|actual], keys, operator) do
    assert_except(he, ha, keys, operator)
    assert_except(expected, actual, keys, operator)
  end

  defp assert_except(expected, actual, _keys, operator) do
    case operator do
      :match -> assert expected === actual
      :equal -> assert expected == actual
    end
  end

  defp except_or_assert(k, v, actual, keys, operator) do
    if Enum.member?(keys, k) do
      true
    else
      assert_except v, Dict.get(actual, k), keys, operator
    end
  end
end