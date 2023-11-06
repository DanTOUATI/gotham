defmodule GothamWeb.JWTAuthPlug do
	import Plug.Conn
	alias Gotham.Gestion
	alias Gotham.Gestion.User
	alias Gotham.AuthTokens

	def init(opts), do: opts

	def call(conn, _) do
		bearer = get_req_header(conn, "authorization") |> List.first()

		if bearer == nil do
			conn |> put_status(401)
		else
			token = bearer |> String.split(" ") |> List.last()

			signer =
				Joken.Signer.create(
					"HS256",
					"d2AUWmpqdoTlIXn/I1CDZ9klK3lurKhW3E4voj4hMnT0E1xbVvaYI6P3JHEkycP4"
				)

				with {:ok, %{"user_id" => user_id}} <-
							 GothamWeb.JWTToken.verify_and_validate(token, signer),
							%User{} = user <- Gestion.get_user(user_id) do

							if AuthTokens.get_auth_token_by_token(token) != nil do
								conn |> put_status(401)
							else
								conn |> assign(:current_user, user)
							end
				else
					{:error, _reason} -> conn |> put_status(401)
					_ -> conn |> put_status(401)
				end
		end
	end
end
