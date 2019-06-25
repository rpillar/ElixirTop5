defmodule Top52.Repo.Migrations.AddUniqueIndexUsers do
  use Ecto.Migration

  def change do
    drop index(:users, [:username])
    create unique_index(:users, [:username])
  end
end
