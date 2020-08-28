defmodule Hush.Provider.AwsSecretsManager.ExAws do
  @moduledoc false
  @behaviour ExAws.Behaviour

  @impl ExAws.Behaviour
  def request(op, config_overrides \\ []) do
    ExAws.request(op, config_overrides)
  end

  @impl ExAws.Behaviour
  def request!(op, config_overrides \\ []) do
    ExAws.request!(op, config_overrides)
  end

  @impl ExAws.Behaviour
  def stream!(op, config_overrides \\ []) do
    ExAws.stream!(op, config_overrides)
  end
end
