defmodule Top52Web.NoteController do
  use Top52Web, :controller

  alias Top52.Tasks
  alias Top52.Tasks.Note

  action_fallback Top52Web.FallbackController

  def index(conn, _params) do
    notes = Tasks.list_notes()
    render(conn, "index.json", notes: notes)
  end

  def create(conn, note_params) do
    IO.inspect note_params
    with {:ok, %Note{} = note} <- Tasks.create_note(note_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.note_path(conn, :show, note))
      |> render("show.json", note: note)
    else
      {:error, %Ecto.Changeset{} } ->
        conn
          |> put_status(422)
          |> render("show.json", note: nil)
    end
  end

  def show(conn, %{"id" => id}) do
    note = Tasks.get_note!(id)
    render(conn, "show.json", note: note)
  end

  def update(conn, %{"id" => id, "note" => note_params}) do
    note = Tasks.get_note!(id)

    with {:ok, %Note{} = note} <- Tasks.update_note(note, note_params) do
      render(conn, "show.json", note: note)
    else
      {:error, %Ecto.Changeset{} } ->
        conn
          |> put_status(422)
          |> render("show.json", note: note)
    end
  end

  def delete(conn, %{"id" => id}) do
    note = Tasks.get_note!(id)

    with {:ok, %Note{}} <- Tasks.delete_note(note) do
      send_resp(conn, :no_content, "")
    end
  end
end
