defmodule Gotham.Gestion.User do
  use Ecto.Schema
  import Ecto.Changeset
	import Comeonin
	alias Gotham.AuthTokens.AuthToken

	@derive {Jason.Encoder, except: [:__meta__, :auth_tokens, :password]}
	schema "users" do
    field :name, :string
		field :surname, :string
    field :email, :string
		field :password, :string
		field :roles, {:array, :string}

		has_many :auth_tokens, AuthToken

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs,[:name, :surname, :email, :password, :roles])
		|> ensure_roles_present()
    |> validate_required([:name, :email, :password ])
		|> validate_length(:name, min: 2, max: 20)
		|> validate_length(:surname, min: 2, max: 20)
		|> validate_length(:password, min: 6, max: 20)
		|> unique_constraint(:email)
		|> update_change(:email, fn email -> String.downcase(email) end)
		|> update_change(:name, &String.downcase(&1))
		|> update_change(:surname, &String.downcase(&1))
		|> validate_format(:email, ~r/^[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+$/i)
		|> hash_password
  end

	defp ensure_roles_present(changeset) do
		if get_change(changeset, :roles) do
			changeset
		else
			put_change(changeset, :roles, ["user"])
		end
	end

	defp hash_password(changeset) do
		case changeset do
			%Ecto.Changeset{valid?: true, changes: %{password: password}} ->
				hashed_password = Pbkdf2.hash_pwd_salt(password)
				put_change(changeset, :password, Pbkdf2.hash_pwd_salt(password))
			_ ->
				changeset
		end
	end
end
