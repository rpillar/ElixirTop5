defmodule Top52Web.NoteView do
  use Top52Web, :view
  alias Top52Web.NoteView

  def render("index.json", %{notes: notes}) do
    %{data: render_many(notes, NoteView, "note.json")}
  end

  def render("show.json", %{note: note}) do
    %{data: render_one(note, NoteView, "note.json")}
  end

  def render("note.json", %{note: note}) do
    %{id: note.id, note: note.note, task_id: note.task_id}
  end
end
