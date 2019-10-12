defmodule Top52.Accounts.User do

  @moduledoc """
  The Accounts User schema / changeset.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Pbkdf2

  schema "users" do
    field :email, :string
    field :password, :string
    field :username, :string
    has_many :tasks, Top52.Tasks.Task

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password])
    |> validate_required([:username, :email, :password])
    |> validate_format(:email, ~r/@/, message: "Invalid email address")
    |> validate_password(:password)
    |> unique_constraint(:username)
    |> update_change(:password, &Pbkdf2.hash_pwd_salt/1)
  end

  defp validate_password(changeset, field, options \\ []) do
    validate_change(changeset, field, fn _, password ->
      case String.length(password) > 7 do
        true  -> []
        false -> [{field, options[:message] || "Password invalid"}]
      end
    end)
  end
end
