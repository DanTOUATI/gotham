defmodule Gotham.AuthTokens.AuthToken do
  use Ecto.Schema
  import Ecto.Changeset
	alias Gotham.Gestion.User

  schema "auth_tokens" do
    field :token, :string
   	#field :user_id, :id

	 	belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(auth_token, attrs) do
    auth_token
    |> cast(attrs, [:token])
    |> validate_required([:token])
  end
end
