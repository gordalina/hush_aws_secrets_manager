defmodule Hush.Provider.ExAwsTest do
  @moduledoc false
  use ExUnit.Case, async: true

  doctest Hush.Provider.AwsSecretsManager
  alias Hush.Provider.AwsSecretsManager

  test "request/1" do
    assert_raise UndefinedFunctionError, fn ->
      AwsSecretsManager.ExAws.request(nil)
    end
  end

  test "request!/1" do
    assert_raise UndefinedFunctionError, fn ->
      AwsSecretsManager.ExAws.request!(nil)
    end
  end

  test "stream!/1" do
    assert_raise UndefinedFunctionError, fn ->
      AwsSecretsManager.ExAws.stream!(nil)
    end
  end
end
