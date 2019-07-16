defmodule Top52.Repo.Migrations.AlterNotesTableAddActionFlag do
  use Ecto.Migration

  def change do
    alter table(:notes) do
      add :action, :boolean, default: false
    end
  end
end
