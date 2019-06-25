defmodule Top52.Repo.Migrations.TaskTableAddBacklogFlag do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
      add :in_backlog, :boolean, default: false
    end
  end
end
