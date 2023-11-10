defmodule GothamWeb.UserController do
  use GothamWeb, :controller

  alias Gotham.Gestion
  alias Gotham.Gestion.User
	alias Plug.Conn

  # alias Gotham.Gestion.Gestion

  action_fallback GothamWeb.FallbackController

  def index(conn, _params) do
    users = Gestion.list_users()
    render(conn, :index, users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Gestion.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> render(:show, user: user)
    end
  end

  def get_user_by_email_and_username(conn, %{"email" => email, "username" => username}) do
    with {:ok, user} <- Gestion.get_user_by_email_and_username(email, username) do
      render(conn, :show, user: user)
    else
      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "user with email: #{email} and username: #{username} not found"})
    end
  end

  def show(conn, %{"id" => id}) do
    user = Gestion.get_user!(id)
    render(conn, :show, user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Gestion.get_user!(id)
    with {:ok, %User{} = user} <- Gestion.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

	def delete(conn, %{"id" => id}) do
    user = Gestion.get_user!(id)
    with {:ok, %User{}} <- Gestion.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
