defmodule Top52Web.UserControllerTest do
  use Top52Web.ConnCase

  alias Top52.Accounts

  @create_attrs %{name: "some name", username: "some username", email: "name@email", password: "password"}
  @invalid_attrs %{name: nil, username: nil}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  describe "create user" do
    test "xxredirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.register_path(conn, :create), user: @create_attrs)
      assert redirected_to(conn) == Routes.task_path(conn, :index)

      conn = get(conn, Routes.task_path(conn, :index))
      assert html_response(conn, 200) =~ "Task List"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.register_path(conn, :create), user: @invalid_attrs)
      assert html_response(conn, 200) =~ "Error : Username"
    end
  end

end
