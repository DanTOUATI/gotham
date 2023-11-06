defmodule GothamWeb.AuthController do
	use GothamWeb, :controller
	import Ecto.Query, warn: false
	import Plug.Conn
	alias Gotham.Gestion
	alias Gotham.Gestion.User
	alias GothamWeb.JWTToken
	alias Gotham.AuthTokens.AuthToken
	alias Gotham.Repo

	def inscription(conn, params) do
		case Gestion.create_user(params) do
			{:ok, user} ->
				json_response = %{success: true, user: user}
				conn
				|> put_resp_content_type("application/json")
				|> send_resp(201, Jason.encode!(json_response))
		end
	end

	def login(conn, %{"email" => email, "password" => password}) do
		with %User{} = user <- Gestion.get_user_by_mail(email),
		 	true <- Pbkdf2.verify_pass(password, user.password) do
				signer =
					Joken.Signer.create(
						"HS256",
						"d2AUWmpqdoTlIXn/I1CDZ9klK3lurKhW3E4voj4hMnT0E1xbVvaYI6P3JHEkycP4"
					)

				extra_claims = %{user_id: user.id}
				{:ok, token, _claims} = JWTToken.generate_and_sign(extra_claims, signer)

				json_response = %{success: true, token: token}
				conn
				|> put_resp_content_type("application/json")
				|> send_resp(201, Jason.encode!(json_response))
			end
	end

	def get(conn, _params) do
		user_data = conn.assigns.current_user
		case user_data do
			%User{} = user ->
				conn
				|> put_resp_content_type("application/json")
				|> send_resp(200, Jason.encode!(%{success: true, user: user}))

			_ ->
				conn
				|> put_status(401)
				|> put_resp_content_type("application/json")
				|> send_resp(401, Jason.encode!(%{success: false, error: "User not found"}))
		end
	end

	def delete(conn, _params) do
		case Ecto.build_assoc(conn.assigns.current_user, :auth_tokens, %{token: get_token(conn)}) do
			%AuthToken{} = auth_token ->
				Repo.insert!(auth_token)
				json_response = %{success: true, message: "Déconnexion"}
					conn
						|> put_resp_content_type("application/json")
						|> send_resp(200, Jason.encode!(json_response))
					_ -> conn
						 |> put_status(401)
						 |> put_resp_content_type("application/json")
						 |> send_resp(401, Jason.encode!(%{success: false, error: "internal server error"}))
		end
	end

	defp get_token(conn) do
		bearer = get_req_header(conn, "authorization") |> List.first()
		if bearer == nil do
		 	""
	 	else
		 	bearer |> String.split(" ") |> List.last()
		end
	end
end
