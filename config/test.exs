import Config

alias Hush.Provider.AwsSecretsManager

config :hush_aws_secrets_manager,
  ex_aws: AwsSecretsManager.MockExAws
