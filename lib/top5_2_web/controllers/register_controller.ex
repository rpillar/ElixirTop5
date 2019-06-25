defmodule Top52Web.RegisterController do
  use Top52Web, :controller

  alias Top52.Accounts
  alias Top52.Accounts.User
  alias Top52Web.Router.Helpers

  def index(conn, params) do
    changeset = User.changeset(%User{}, params)
    conn
    |> put_flash(:info, "Enter all details to sign-up for this service.")
    |> render("index.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> clear_flash
        |> put_session(:current_user_id, user.id)
        |> put_flash(:info, "User created successfully" )
        |> redirect(to: Helpers.task_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        {fld, {msg, _}} = List.first(changeset.errors)
        conn
        |> clear_flash
        |> put_flash(:error, "Error : #{String.capitalize(Atom.to_string(fld))} - #{msg}" )
        |> render("index.html", changeset: changeset)
    end
  end

end