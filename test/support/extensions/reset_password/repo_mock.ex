defmodule PowResetPassword.Test.RepoMock do
  @moduledoc false
  alias PowResetPassword.Test.Users.User

  @user %User{id: 1}

  def get_by(schema, params, opts \\ %{})
  def get_by(User, [email: "test@example.com"], _opts), do: @user
  def get_by(User, [email: "invalid@example.com"], _opts), do: nil

  def update(changeset, opts \\ %{})
  def update(%{valid?: true} = changeset, _opts) do
    user = Ecto.Changeset.apply_changes(changeset)

    # We store the user in the process because the user is force reloaded with `get!/2`
    Process.put({:user, 1}, user)

    {:ok, user}
  end
  def update(%{valid?: false} = changeset, _opts), do: {:error, %{changeset | action: :update}}

  def get!(schema, id, opts \\ %{})
  def get!(User, 1, _opts), do: Process.get({:user, 1})
  def get!(User, :missing, _opts), do: nil
end
