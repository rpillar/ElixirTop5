defmodule Top52Web.NoteControllerTest do
  use Top52Web.ConnCase

  alias Top52.Accounts
  alias Top52.Tasks
  alias Top52.Tasks.Note

  @user %{email: "test@test.com", password: "password123", username: "testing"}

  @task %{deadline: ~D[2021-04-17], priority: "some priority", status: "some status", task_description: "some task_description", taskname: "some taskname", in_backlog: false}

  @create_attrs %{
    note: "some note", action: false
  }
  @update_attrs %{
    note: "some updated note"
  }
  @invalid_attrs %{note: nil}

  def note_fixture(attrs \\ %{}) do
    {:ok, user} =
      Enum.into(%{}, @user)
      |> Accounts.create_user()

    {:ok, task} =
      Enum.into(%{}, @task)
      |> Map.put(:user_id, user.id)
      |> Tasks.create_task()

    note_data =
      attrs
      |> Enum.into(@create_attrs)
      |> Map.put(:task_id, task.id)

    note_data
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
      conn = post(conn, Routes.note_path(conn, :create), note: note_fixture())
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.note_path(conn, :show, id))

      assert %{
               "id" => id,
               "note" => "some note"
             } = json_response(conn, 200)["data"]
    end

    @tag :skip
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.note_path(conn, :create), note: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update note" do
    setup [:create_note]

    @tag :skip
    test "renders note when data is valid", %{conn: conn, note: %Note{id: id} = note} do
      conn = put(conn, Routes.note_path(conn, :update, note), note: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.note_path(conn, :show, id))

      assert %{
               "id" => id,
               "note" => "some updated note"
             } = json_response(conn, 200)["data"]
    end

    @tag :skip
    test "renders errors when data is invalid", %{conn: conn, note: note} do
      conn = put(conn, Routes.note_path(conn, :update, note), note: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete note" do
    setup [:create_note]

    @tag :skip
    test "deletes chosen note", %{conn: conn, note: note} do
      conn = delete(conn, Routes.note_path(conn, :delete, note))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.note_path(conn, :show, note))
      end
    end
  end

  defp create_note(_) do
    note = note_fixture(:note)
    {:ok, note: note}
  end
end
