defmodule Hush.Provider.AwsSecretsManager.ExAws do
  @moduledoc false
  @behaviour ExAws.Behaviour

  @impl ExAws.Behaviour
  def request(op, config_overrides \\ []), do: impl().request(op, config_overrides)

  @impl ExAws.Behaviour
  def request!(op, config_overrides \\ []), do: impl().request!(op, config_overrides)

  @impl ExAws.Behaviour
  def stream!(op, config_overrides \\ []), do: impl().stream!(op, config_overrides)

  defp impl, do: Application.get_env(:hush_aws_secrets_manager, :ex_aws, ExAws)
end
