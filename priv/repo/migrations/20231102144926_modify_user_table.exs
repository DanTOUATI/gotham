defmodule Gotham.Repo.Migrations.ModifyUserTable do
  use Ecto.Migration

  def change do
		alter table(:users) do
			add :name, :string
			add :surname, :string
			add :password, :string
			add :roles, {:array, :string}
		end
  end
end
