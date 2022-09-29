alias Hush.Provider.AwsSecretsManager

ExUnit.start()

Mox.defmock(AwsSecretsManager.MockExAws, for: ExAws.Behaviour)
Application.put_env(:hush_aws_secrets_manager, :ex_aws, AwsSecretsManager.MockExAws)
