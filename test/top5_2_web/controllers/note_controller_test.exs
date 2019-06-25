defmodule Top52Web.NoteControllerTest do
  use Top52Web.ConnCase

  alias Top52.Tasks
  alias Top52.Tasks.Note

  @create_attrs %{
    note: "some note"
  }
  @update_attrs %{
    note: "some updated note"
  }
  @invalid_attrs %{note: nil}

  def fixture(:note) do
    {:ok, note} = Tasks.create_note(@create_attrs)
    note
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all notes", %{conn: conn} do
      conn = get(conn, Routes.note_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create note" do
    test "renders note when data is valid", %{conn: conn} do
      conn = post(conn, Routes.note_path(conn, :create), note: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.note_path(conn, :show, id))

      assert %{
               "id" => id,
               "note" => "some note"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.note_path(conn, :create), note: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update note" do
    setup [:create_note]

    test "renders note when data is valid", %{conn: conn, note: %Note{id: id} = note} do
      conn = put(conn, Routes.note_path(conn, :update, note), note: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.note_path(conn, :show, id))

      assert %{
               "id" => id,
               "note" => "some updated note"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, note: note} do
      conn = put(conn, Routes.note_path(conn, :update, note), note: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete note" do
    setup [:create_note]

    test "deletes chosen note", %{conn: conn, note: note} do
      conn = delete(conn, Routes.note_path(conn, :delete, note))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.note_path(conn, :show, note))
      end
    end
  end

  defp create_note(_) do
    note = fixture(:note)
    {:ok, note: note}
  end
end
