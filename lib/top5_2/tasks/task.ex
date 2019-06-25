defmodule Top52.Tasks.Task do

  @moduledoc """
  The Tasks Task schema / changeset.
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :deadline, :date
    field :in_backlog, :boolean, default: false
    field :priority, :string
    field :status, :string
    field :task_description, :string
    field :taskname, :string
    belongs_to :user, Top52.Accounts.User
    has_many :notes, Top52.Tasks.Note

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:taskname, :task_description, :status, :in_backlog, :deadline, :priority, :user_id])
    |> validate_required([:taskname, :task_description, :status, :in_backlog, :deadline, :priority, :user_id])
  end

  def transform_timestamp(timestamp) do
    timestamp
      |> Kernel.inspect 
      |> String.slice(3, 10)
  end
end
