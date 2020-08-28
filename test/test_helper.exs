alias Hush.Provider.AwsSecretsManager

ExUnit.start()

Mox.defmock(AwsSecretsManager.MockExAws, for: ExAws.Behaviour)
