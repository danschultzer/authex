defmodule PowEmailConfirmation.Ecto.Schema do
  @moduledoc false
  use Pow.Extension.Ecto.Schema.Base
  alias Ecto.Changeset
  alias Pow.{Extension.Ecto.Schema, UUID}

  def validate!(_config, module) do
    Schema.require_schema_field!(module, :email, PowEmailConfirmation)
  end

  def attrs(_config) do
    [{:email_confirmation_token, :string},
     {:email_confirmed_at, :utc_datetime}]
  end

  def indexes(_config) do
    [{:email_confirmation_token, true}]
  end

  def changeset(changeset, _attrs, _config) do
    changeset
    |> put_email_confirmation_token()
    |> Changeset.validate_required([:email_confirmation_token])
    |> Changeset.unique_constraint(:email_confirmation_token)
  end

  defp put_email_confirmation_token(changeset) do
    current_email = changeset.data.email

    changeset
    |> Changeset.get_field(:email)
    |> case do
      ^current_email -> changeset
      _new_email -> Changeset.put_change(changeset, :email_confirmation_token, UUID.generate())
    end
  end
end