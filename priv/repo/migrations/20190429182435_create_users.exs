defmodule Top52.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :password, :string
      add :username, :string

      timestamps()
    end

  end
end
