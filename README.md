# AWS Secrets Manager Hush Provider

[![Build Status](https://img.shields.io/github/workflow/status/gordalina/hush_aws_secrets_manager/ci?style=flat-square)](https://github.com/gordalina/hush_aws_secrets_manager/actions?query=workflow%3A%22ci%22)
[![Coverage Status](https://img.shields.io/codecov/github/gordalina/hush_aws_secrets_manager?style=flat-square)](https://app.codecov.io/gh/gordalina/hush_aws_secrets_manager)
[![hex.pm version](https://img.shields.io/hexpm/v/hush_aws_secrets_manager?style=flat-square)](https://hex.pm/packages/hush_aws_secrets_manager)
[![hex.pm downloads](https://img.shields.io/hexpm/dt/hush_aws_secrets_manager?style=flat-square)]([LICENSE](https://hex.pm/packages/hush_aws_secrets_manager))

This package provides a [Hush](https://github.com/gordalina/hush) Provider to resolve Amazon Web Services's [Secrets Manager](https://aws.amazon.com/secrets-manager/) secrets.

Documentation can be found at [https://hexdocs.pm/hush_aws_secrets_manager](https://hexdocs.pm/hush_aws_secrets_manager).

## Installation

The package can be installed by adding `hush_aws_secrets_manager` to your list
of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:hush, "~> 0.4"},
    {:hush_aws_secrets_manager, "~> 1.0.0-rc.0"}
  ]
end
```

This module relies on `ex_aws` to talk to the AWS API. As such you need to configure it, below is an example, but you can read alternative ways of configuring it in [their documentation](https://github.com/ex-aws/ex_aws).

As the provider needs to start `ex_aws` application, it needs to registered as a provider in `hush`, so that it gets loaded during startup.

```elixir
# config/config.exs

alias Hush.Provider.AwsSecretsManager

config :ex_aws,
  access_key_id: [{:system, "AWS_ACCESS_KEY_ID"}],
  secret_access_key: [{:system, "AWS_SECRET_ACCESS_KEY"}]

# ensure hush loads AwsSecretsManager during startup
config :hush,
  providers: [AwsSecretsManager]
```

### AWS Authorization

In order to retrieve secrets from AWS, ensure the service account you use has a similar policy as:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "secretsmanager:GetSecretValue",
      "Resource": [
        "arn:aws:secretsmanager:<region>:<account>:secret:<secret-name>",
        "arn:aws:secretsmanager:us-east-1:000000000000:secret:config/password-MzBAO2"
      ]
    }
  ]
}
```

## Usage

The following example reads the password and the pool size for CloudSQL from secret manager into the ecto repo configuration.

```elixir
# config/prod.exs

alias Hush.Provider.AwsSecretsManager

config :app, App.Repo,
  password: {:hush, AwsSecretsManager, "CLOUDSQL_PASSWORD"},
  pool_size: {:hush, AwsSecretsManager, "ECTO_POOL_SIZE", cast: :integer, default: 10}
```

## License

Hush is released under the Apache License 2.0 - see the [LICENSE](LICENSE) file.
