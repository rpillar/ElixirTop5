defmodule Top52.Repo.Migrations.CreateNotes do
  use Ecto.Migration

  def change do
    create table(:notes) do
      add :note, :string

      timestamps()
    end
  end
end
