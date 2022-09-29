defmodule Hush.Provider.AwsSecretsManager do
  @moduledoc """
  Implements a Hush.Provider behaviour to resolve secrets from
  AWS Secrets Manager at runtime.

  To configure this provider, ensure you configure ex_aws and hush:

      config :ex_aws,
        access_key_id: [{:system, "AWS_ACCESS_KEY_ID"}],
        secret_access_key: [{:system, "AWS_SECRET_ACCESS_KEY"}]

      config :hush,
        providers: [Hush.Provider.AwsSecretsManager]
  """

  alias Hush.Provider.AwsSecretsManager

  @behaviour Hush.Provider

  @impl Hush.Provider
  @spec load(config :: any()) :: :ok | {:error, any()}
  def load(_config) do
    with {:ok, _} <- Application.ensure_all_started(:hackney),
         {:ok, _} <- Application.ensure_all_started(:ex_aws) do
      :ok
    end
  end

  @impl Hush.Provider
  @spec fetch(key :: String.t()) :: {:ok, String.t()} | {:error, :not_found} | {:error, any()}
  def fetch(key) do
    with {:ok, secret} <- secret(key),
         {:ok, value} <- json_decode(secret["SecretString"]) do
      {:ok, value}
    else
      error -> parse_error(error, key)
    end
  end

  defp secret(key) do
    key
    |> ExAws.SecretsManager.get_secret_value()
    |> AwsSecretsManager.ExAws.request()
  end

  defp json_decode(json) do
    try do
      defaults = ExAws.Config.Defaults.defaults(:all)
      codec = defaults[:json_codec]
      {:ok, codec.decode!(json)}
    rescue
      e -> {:error, "Could not parse JSON: #{e.data}"}
    end
  end

  defp parse_error({:error, {:http_error, 400, response}}, key) do
    if String.match?(response.body, ~r/is not authorized to perform/) do
      {:ok, error} = json_decode(response.body)

      msg = """
      The supplied account doesn't seem to have access to secret
      '#{key}', or secret does not exist. Ensure that it is:

        1) spelled correctly
        2) you have specified the right authentication credentials
        3) the account has enough permissions

      The original error message was: #{error["Message"]}
      """

      {:error, msg}
    else
      parse_error(response, key)
    end
  end

  defp parse_error({:error, message}, _key) when is_binary(message) do
    {:error, message}
  end

  defp parse_error(_error, key) do
    {:error, "An unknown error ocurred while fethching secret for #{key}"}
  end
end
