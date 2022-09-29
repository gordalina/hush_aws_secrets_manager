defmodule Hush.Provider.AwsSecretsManagerTest do
  @moduledoc false

  use ExUnit.Case
  import Mox

  doctest Hush.Provider.AwsSecretsManager
  alias Hush.Provider.AwsSecretsManager

  describe "load/1" do
    test "works with nil" do
      assert :ok == AwsSecretsManager.load(nil)
    end
  end

  describe "fetch/1" do
    test "ok" do
      AwsSecretsManager.MockExAws
      |> expect(:request, 1, fn _, _ -> {:ok, %{"SecretString" => "{\"key\":\"val\"}"}} end)

      assert {:ok, %{"key" => "val"}} == AwsSecretsManager.fetch("KEY_BASE")
    end

    test "json parse error" do
      AwsSecretsManager.MockExAws
      |> expect(:request, 1, fn _, _ -> {:ok, %{"SecretString" => "invalid json"}} end)

      assert {:error, "Could not parse JSON: invalid json"} == AwsSecretsManager.fetch("KEY_BASE")
    end

    test "unknown secret" do
      AwsSecretsManager.MockExAws
      |> expect(:request, 1, fn _, _ ->
        body =
          "{\"__type\":\"AccessDeniedException\",\"Message\":\"User: arn:aws:iam::000000000000:user/user is not authorized to perform: secretsmanager:GetSecretValue on resource: arn:aws:secretsmanager:us-east-1:000000000000:secret:KEY_BASE\"}"

        {:error, {:http_error, 400, %{body: body, status_code: 400}}}
      end)

      message = """
      The supplied account doesn't seem to have access to secret
      'KEY_BASE', or secret does not exist. Ensure that it is:

        1) spelled correctly
        2) you have specified the right authentication credentials
        3) the account has enough permissions

      The original error message was: User: arn:aws:iam::000000000000:user/user is not authorized to perform: secretsmanager:GetSecretValue on resource: arn:aws:secretsmanager:us-east-1:000000000000:secret:KEY_BASE
      """

      assert {:error, message} == AwsSecretsManager.fetch("KEY_BASE")
    end

    test "random error" do
      AwsSecretsManager.MockExAws
      |> expect(:request, 1, fn _, _ ->
        body = "{\"__type\":\"RandomErrorException\",\"Message\":\"Random Error\"}"
        {:error, {:http_error, 400, %{body: body, status_code: 400}}}
      end)

      message = "An unknown error ocurred while fethching secret for KEY_BASE"
      assert {:error, message} == AwsSecretsManager.fetch("KEY_BASE")
    end
  end
end
