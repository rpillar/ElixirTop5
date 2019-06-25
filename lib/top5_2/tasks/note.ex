defmodule Top52.Tasks.Note do

  @moduledoc """
  The Tasks Note schema / changeset.
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "notes" do
    field :note, :string
    belongs_to :task, Top52.Tasks.Task

    timestamps()
  end

  @doc false
  def changeset(note, attrs) do
    note
    |> cast(attrs, [:note, :task_id])
    |> validate_required([:note, :task_id])
  end
end
