defmodule Gotham.AuthTokensFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Gotham.AuthTokens` context.
  """

  @doc """
  Generate a auth_token.
  """
  def auth_token_fixture(attrs \\ %{}) do
    {:ok, auth_token} =
      attrs
      |> Enum.into(%{
        token: "some token"
      })
      |> Gotham.AuthTokens.create_auth_token()

    auth_token
  end
end
