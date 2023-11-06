defmodule GothamWeb.Router do
  use GothamWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {GothamWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

	pipeline :auth do
		plug GothamWeb.JWTAuthPlug
	end

	scope "/api/auth", GothamWeb do
		pipe_through :auth
		get "/", AuthController, :get
		delete "/", AuthController, :delete
	end

#  scope "/", GothamWeb do
#    pipe_through :browser
#
#    get "/", PageController, :home
  #end

  # Other scopes may use custom stacks.
   scope "/api", GothamWeb do
     pipe_through :api
     #resources "/users", UserController, except: [:new, :edit]
		 #resources "/clocks", ClockController, except: [:new, :edit]
		 #resources "/working_times", WorkingTimeController, except: [:new, :edit]

		 get("/users", UserController, :get_user_by_email_and_username)
     get("/usersAll", UserController, :index)
     get("/users/:id", UserController, :show)
     post("/users", UserController, :create)
     put("/users/:id", UserController, :update)
     delete("/users/:id", UserController, :delete)

     get("/clocksAll", ClockController, :index)
     get("/clocks/:user_id", ClockController, :get_all_clock_by_userid)
     get("/clocks/data/:id", ClockController, :show)
     post("/clocks/:user_id", ClockController, :create)

     get("/working_timesAll/:user_id", WorkingTimeController, :get_WKAll)
     get("/working_times/:user_id", WorkingTimeController, :get_all_workingTime_by_userid)
     get("/working_times/:user_id/:id", WorkingTimeController, :get_working_time_by_id)
     post("/working_times/:user_id", WorkingTimeController, :create)
     put("/working_times/:id", WorkingTimeController, :update)
     delete("/working_times/:id", WorkingTimeController, :delete)
    #get("/working_times/:user_id", WorkingTimeController, :show)

		post("/inscription", AuthController, :inscription)
		post("/login", AuthController, :login)

	end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:gotham, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: GothamWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
