defmodule Top52Web.HomeController do
  use Top52Web, :controller

  alias Top52.Accounts
  alias Top52Web.Router.Helpers

  def index(conn, _params) do
    conn
    |> put_flash(:info, "Login using your Username / Password")
    |> render("index.html")
  end

  def sign_in(conn, %{"session" => auth_params}) do
    username = auth_params["username"]
    password = auth_params["password"]

    with {:ok, _ } <- validate_signin(auth_params),
         {:ok, user} <- authenticate_user(username, password)
    do
      conn
        |> clear_flash
        |> put_session(:current_user_id, user.id)
        |> put_flash(:info, "Signedin successfully" )
        |> redirect(to: Helpers.task_path(conn, :index))
    else
      _ -> conn
        |> clear_flash
        |> put_flash(:error, "Error - Username or Password is missing / incorrect" )
        |> render("index.html")
    end
  end

  defp authenticate_user(username, password) do
    case user = Accounts.get_user_by_username(username) do
      nil ->
        {:error, :invalid_data}
      user ->
        if Pbkdf2.verify_pass(password, user.password) do
          IO.puts "auth - success"
          {:ok, user}
        else
          IO.puts "auth - failed"
          {:error, :invalid_data}
        end
    end
  end

  defp validate_signin(params) do
    case (Map.values(params) == ["", ""]) do
      true ->
        {:error, 'error'}
      false ->
        {:ok, 'success'}
    end
  end

end
