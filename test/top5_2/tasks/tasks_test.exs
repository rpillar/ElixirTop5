defmodule Top52.TasksTest do
  use Top52.DataCase

  alias Top52.Accounts
  alias Top52.Tasks

  describe "tasks" do
    alias Top52.Tasks.Task

    @user %{email: "test@test.com", password: "password123", username: "testing"}

    @valid_attrs %{deadline: ~D[2010-04-17], priority: "some priority", status: "some status", task_description: "some task_description", taskname: "some taskname", in_backlog: false}
    @update_attrs %{deadline: ~D[2011-05-18], priority: "some updated priority", status: "some updated status", task_description: "some updated task_description", taskname: "some updated taskname", in_backlog: false}
    @invalid_attrs %{deadline: nil, priority: nil, status: nil, task_description: nil, taskname: nil, in_backlog: nil}

    def task_fixture(attrs \\ %{}) do
      {:ok, user} = 
        Enum.into(%{}, @user)
        |> Accounts.create_user()

      task_data = 
        attrs
        |> Enum.into(@valid_attrs)
        |> Map.put(:user_id, user.id)

      task_data
    end

    test "list_tasks/0 returns all tasks" do
      {:ok, task} = Tasks.create_task( task_fixture() )
      assert Tasks.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      {:ok, task} = Tasks.create_task( task_fixture() )
      assert Tasks.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      assert {:ok, %Task{} = task} = Tasks.create_task( task_fixture() )
      assert task.deadline == ~D[2010-04-17]
      assert task.priority == "some priority"
      assert task.status == "some status"
      assert task.task_description == "some task_description"
      assert task.taskname == "some taskname"
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tasks.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      assert {:ok, %Task{} = task} = Tasks.create_task( task_fixture() )
      assert {:ok, %Task{} = task} = Tasks.update_task(task, @update_attrs)
      assert task.deadline == ~D[2011-05-18]
      assert task.priority == "some updated priority"
      assert task.status == "some updated status"
      assert task.task_description == "some updated task_description"
      assert task.taskname == "some updated taskname"
    end

    test "update_task/2 with invalid data returns error changeset" do
      assert {:ok, %Task{} = task} = Tasks.create_task( task_fixture() )
      assert {:error, %Ecto.Changeset{}} = Tasks.update_task(task, @invalid_attrs)
      #assert task == Tasks.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      assert {:ok, %Task{} = task} = Tasks.create_task( task_fixture() )
      assert {:ok, %Task{}} = Tasks.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Tasks.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      assert {:ok, %Task{} = task} = Tasks.create_task( task_fixture() )
      assert %Ecto.Changeset{} = Tasks.change_task(task)
    end
  end

  describe "notes" do
    alias Top52.Tasks.Note

    @task %{deadline: ~D[2010-04-17], priority: "some priority", status: "some status", task_description: "some task_description", taskname: "some taskname", in_backlog: false}

    @valid_attrs %{note: "some note", action: false}
    @update_attrs %{note: "some updated note"}
    @invalid_attrs %{note: nil}

    def note_fixture(attrs \\ %{}) do
      {:ok, task} =
        Enum.into(%{}, @task)
        |> Tasks.create_task()

      {:ok, note} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Map.put(:task_id, task.id)
        |> Tasks.create_note()

      note
    end

    test "list_notes/0 returns all notes" do
      note = note_fixture()
      assert Tasks.list_notes() == [note]
    end

    test "get_note!/1 returns the note with given id" do
      note = note_fixture()
      assert Tasks.get_note!(note.id) == note
    end

    test "create_note/1 with valid data creates a note" do
      assert {:ok, %Note{} = note} = Tasks.create_note(@valid_attrs)
      assert note.note == "some note"
    end

    test "create_note/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tasks.create_note(@invalid_attrs)
    end

    test "update_note/2 with valid data updates the note" do
      note = note_fixture()
      assert {:ok, %Note{} = note} = Tasks.update_note(note, @update_attrs)
      assert note.note == "some updated note"
    end

    test "update_note/2 with invalid data returns error changeset" do
      note = note_fixture()
      assert {:error, %Ecto.Changeset{}} = Tasks.update_note(note, @invalid_attrs)
      assert note == Tasks.get_note!(note.id)
    end

    test "delete_note/1 deletes the note" do
      note = note_fixture()
      assert {:ok, %Note{}} = Tasks.delete_note(note)
      assert_raise Ecto.NoResultsError, fn -> Tasks.get_note!(note.id) end
    end

    test "change_note/1 returns a note changeset" do
      note = note_fixture()
      assert %Ecto.Changeset{} = Tasks.change_note(note)
    end
  end
end
