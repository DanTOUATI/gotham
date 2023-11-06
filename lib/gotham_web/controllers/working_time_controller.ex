defmodule GothamWeb.WorkingTimeController do
  use GothamWeb, :controller

  alias Gotham.Gestion
  alias Gotham.Gestion.WorkingTime

  action_fallback GothamWeb.FallbackController

  def index(conn, _params) do
    working_times = Gestion.list_working_times()
    render(conn, :index, working_times: working_times)
  end

  def create(conn, %{"user_id" => user_id, "working_time" => working_time_params}) do
    with {:ok, %WorkingTime{} = working_time} <- Gestion.create_working_time(Map.merge(working_time_params, %{"user_id" => user_id})) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~s"/api/working_times/#{working_time.id}")
      |> render(:show, working_time: working_time)
    end
  end

  def show(conn, %{"id" => id}) do
    working_time = Gestion.get_working_time!(id)
    render(conn, :show, working_time: working_time)
  end

  def get_all_workingTime_by_userid(conn, %{"user_id" => user_id, "start" => debut, "end" => fin}) do
    working_times = Gestion.get_all_workingTime_by_userid(user_id, debut, fin)
    render(conn, :index, working_times: working_times)
  end

  def get_working_time_by_id(conn, %{"user_id" => user_id, "id" => id}) do
    working_times = Gestion.get_working_time_by_id(user_id, id)
    render(conn, :index, working_times: working_times)
  end

	def get_WKAll(conn, %{"user_id" => user_id}) do
		working_times = Gestion.get_all_wt(user_id)
		render(conn, :index, working_times: working_times)
	end

  def update(conn, %{"id" => id, "working_time" => working_time_params}) do
    working_time = Gestion.get_working_time!(id)

    with {:ok, %WorkingTime{} = working_time} <- Gestion.update_working_time(working_time, working_time_params) do
      render(conn, :show, working_time: working_time)
    end
  end

  def delete(conn, %{"id" => id}) do
    working_time = Gestion.get_working_time!(id)

    with {:ok, %WorkingTime{}} <- Gestion.delete_working_time(working_time) do
      send_resp(conn, :no_content, "")
    end
  end
end
