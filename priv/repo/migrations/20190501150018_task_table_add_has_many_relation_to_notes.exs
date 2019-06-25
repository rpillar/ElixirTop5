defmodule Top52.Repo.Migrations.TaskTableAddHasManyRelationToNotes do
  use Ecto.Migration

  def change do
    alter table(:notes) do
      add :task_id, references(:tasks)
    end
  end
end
