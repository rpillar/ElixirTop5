defmodule Top52.Repo.Migrations.AddIndexUsers do
   use Ecto.Migration

  def change do
    create index(:users, [:username])
  end
end
