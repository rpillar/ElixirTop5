defmodule Top52.Repo.Migrations.TasksTableAlterDeadlineFieldType do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
      modify :deadline, :date
    end
  end
end
