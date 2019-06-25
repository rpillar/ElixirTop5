defmodule Top52.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :deadline, :date
      add :priority, :string
      add :status, :string
      add :task_description, :string
      add :taskname, :string

      timestamps()
    end

  end
end
