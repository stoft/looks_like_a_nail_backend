defmodule AssertMoreTest do
  use ExUnit.Case, async: true

  import AssertMore

  test "assert equal except, with simple string" do
    try do
      "This should never be tested" = assert_equal_except("expected", "actual")
    rescue 
      error in [ExUnit.AssertionError] ->
        "Assertion with == failed" = error.message
    end
  end

  test "assert equal except with list comparison" do
    try do
      "This should never be tested" = assert_equal_except([:expected], [:actual])
    rescue 
      error in [ExUnit.AssertionError] ->
        "Assertion with == failed" = error.message
    end
  end

  test "assert equal except with map comparison" do
    try do
      "This should never be tested" = assert_equal_except(%{:expected => "expected"}, %{:actual => "actual"})
    rescue 
      error in [ExUnit.AssertionError] ->
        "Assertion with == failed" = error.message
    end
  end

  test "assert equal except with keyword comparison" do
    try do
      "This should never be tested" = assert_equal_except([expected: "expected"], [actual: "actual"])
    rescue 
      error in [ExUnit.AssertionError] ->
        "Assertion with == failed" = error.message
    end
  end

  test "assert equal except with map comparison and ignored fields" do
    assert assert_equal_except(%{:expected => "expected"}, %{:expected => "actual"}, [:expected])
  end

  test "assert equal except with nested map comparison" do
    expected = %{:map => %{:expected => "expected"}}
    actual = %{:map => %{:expected => "actual"}}
    try do
      "This should never be tested" = assert_equal_except(expected, actual)
    rescue 
      error in [ExUnit.AssertionError] ->
        "Assertion with == failed" = error.message
    end
  end

  test "assert equal except with nested map comparison, ignored field" do
    expected = %{:map => %{:expected => "expected", :foo => :bar}}
    actual = %{:map => %{:expected => "actual", :foo => :bar}}
    assert assert_equal_except(expected, actual, [:expected])
  end

  test "assert equal except with keywords" do
    expected = [a: 1, b: 2]
    actual = [a: 1, b: 3]
    try do
      "This should never be tested" = assert_equal_except(expected, actual)
    rescue 
      error in [ExUnit.AssertionError] ->
        "Assertion with == failed" = error.message
    end
  end

  test "assert equal except with keywords, ignored field" do
    expected = [a: 1, b: 2]
    actual = [a: 1, b: 3]
    assert assert_equal_except(expected, actual, [:b])
  end

  test "assert equal except handles different types" do
    expected = %{"foo" => %{"bar" => "baz"}}
    actual = %{"foo" => [%{"bar" => "baz"}]}
    try do
      "This should never be tested" = assert_equal_except(expected, actual)
    rescue 
      error in [ExUnit.AssertionError] ->
        "Assertion with == failed" = error.message
    end

  end
  
end