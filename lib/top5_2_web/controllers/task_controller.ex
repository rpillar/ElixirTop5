defmodule Top52Web.TaskController do
    use Top52Web, :controller

    alias Top52.Accounts
    alias Top52.Tasks
    alias Top52.Tasks.Task
    alias Top52Web.Router.Helpers

    plug :check_auth

    def create_task(conn, %{"task" => task_params}) do
        user_id   = get_session(conn, :current_user_id)
        task_data = Map.put(task_params, "user_id", user_id)

        case Tasks.create_task(task_data) do
          {:ok, _task} ->
            changeset = Task.changeset(%Task{}, task_params)
            tasks     = Tasks.list_active_tasks_by_user(user_id)

            conn
            |> put_flash(:info, "Your Top 5 Tasks.")
            |> render("index.html", tasks: tasks, changeset: changeset, page: "Active")
          {:error, %Ecto.Changeset{} = changeset} ->
            {fld, {msg, _}} = List.first(changeset.errors)
            
            conn
            |> clear_flash
            |> put_flash(:error, "Error : #{String.capitalize(Atom.to_string(fld))} - #{msg}" )
            |> render("create_task.html", changeset: changeset, task_count: task_count(user_id))
        end
    end

    def index(conn, params) do
      user_id = get_session(conn, :current_user_id)

      changeset  = Task.changeset(%Task{}, params)
      tasks      = Tasks.list_active_tasks_by_user(user_id)

      conn
      |> put_flash(:info, "Your Top 5 Tasks.")
      |> render("index.html", tasks: tasks, changeset: changeset, page: "Active")
    end

    def logout(conn, _params) do
        conn
        |> delete_session(:current_user_id)
        |> redirect(to: Helpers.home_path(conn, :index))
    end

    def show_backlog_tasks(conn, params) do
      user_id = get_session(conn, :current_user_id)

      changeset  = Task.changeset(%Task{}, params)
      tasks      = Tasks.list_backlog_tasks_by_user(user_id)

      conn
      |> put_flash(:info, "Your Backlog Tasks.")
      |> render("index.html", tasks: tasks, changeset: changeset, page: "Backlog")
    end

    def show_completed_tasks(conn, params) do
      user_id = get_session(conn, :current_user_id)

      changeset  = Task.changeset(%Task{}, params)
      tasks      = Tasks.list_completed_tasks_by_user(user_id)

      conn
      |> put_flash(:info, "Your Completed Tasks.")
      |> render("index.html", tasks: tasks, changeset: changeset, page: "Completed")
    end

    def show_create_task(conn, params) do
        user_id   = get_session(conn, :current_user_id)
        changeset = Task.changeset(%Task{}, params)

        conn
        |> put_flash(:info, "Enter details and then Save.")
        |> render("create_task.html", changeset: changeset, task_count: task_count(user_id))
    end

    def show_edit_task(conn, %{"id" => id}) do
        task      = Tasks.get_task!(id)
        changeset = Task.changeset(task, %{})

        conn
        |> put_flash(:info, "Update details and then Save.")
        |> render("edit_task_details.html", task: task, changeset: changeset)
    end

    def update_task(conn, %{"id" => id, "task" => task_params}) do
      task = Tasks.get_task!(id)
    
      case Tasks.update_task(task, task_params) do
        {:ok, _task} ->
          user_id = get_session(conn, :current_user_id)
          tasks   = Tasks.list_active_tasks_by_user(user_id)

          conn
          |> put_flash(:info, "Your Top5 Tasks.")
          |> render("index.html", tasks: tasks, page: "Active")
        {:error, _} ->
          IO.puts "Update of task failed"
      end
    end

    def update_task_status(conn) do
      conn
    end

    defp check_auth(conn, _params) do
        if user_id = get_session(conn, :current_user_id) do
            current_user = Accounts.get_user!(user_id)
            conn
            |> assign(:current_user, current_user)
        else
            conn
            |> clear_flash
            |> put_flash(:error, "Error : You need to login to access the service.")
            |> redirect(to: Helpers.home_path(conn, :index))
        end
    end

    defp task_count(user_id) do
      task_count = 
        Tasks.list_active_tasks_by_user(user_id)
        |> Enum.count

      task_count
    end

  end