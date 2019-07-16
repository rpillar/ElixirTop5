defmodule Top52.Tasks.Note do

  @moduledoc """
  The Tasks Note schema / changeset.
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "notes" do
    field :note, :string
    field :action, :boolean
    belongs_to :task, Top52.Tasks.Task

    timestamps()
  end

  @doc false
  def changeset(note, attrs) do
    note
    |> cast(attrs, [:note, :action, :task_id])
    |> validate_required([:note, :action, :task_id])
  end
end
