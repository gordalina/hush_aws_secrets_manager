defmodule Hush.Provider.ExAwsTest do
  @moduledoc false
  use ExUnit.Case, async: true

  import Mox

  doctest Hush.Provider.AwsSecretsManager
  alias Hush.Provider.AwsSecretsManager

  test "request/1" do
    AwsSecretsManager.MockExAws
    |> expect(:request, 1, fn _, _ -> AwsSecretsManager.ExAws.request(:mock) end)
  end

  test "request!/1" do
    AwsSecretsManager.MockExAws
    |> expect(:request!, 1, fn _, _ -> AwsSecretsManager.ExAws.request!(:mock) end)
  end

  test "stream!/1" do
    AwsSecretsManager.MockExAws
    |> expect(:stream!, 1, fn _, _ -> AwsSecretsManager.ExAws.stream!(:mock) end)
  end
end
