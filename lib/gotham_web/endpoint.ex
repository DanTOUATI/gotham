defmodule GothamWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :gotham

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  @session_options [
    store: :cookie,
    key: "_gotham_key",
    signing_salt: "+sM7XsQ+",
    same_site: "Lax"
  ]

  socket "/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]]

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :gotham,
    gzip: false,
    only: GothamWeb.static_paths()

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :gotham
  end

  plug Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
	plug Corsica,
			 origins: "http://localhost:8080", # Spécifiez l'origine à partir de laquelle les requêtes CORS sont autorisées
			 allow_headers: :all, # Vous pouvez personnaliser les autres options CORS selon vos besoins
			 allow_methods: :all,
			 protocol_options: [
				 max_header_name_length: 64,
				 max_header_value_length: 4096,
				 max_headers: 100,
				 max_request_line_length: 8096
			 ],
			 allow_credentials: true
	plug GothamWeb.Router
end
