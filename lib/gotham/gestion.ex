defmodule Gotham.Gestion do
	@moduledoc """
	The Gestion context.
	"""

	import Ecto.Query, warn: false
  #use Ecto.Schema
	alias Gotham.Repo

	alias Gotham.Gestion.User

	@doc """
	Returns the list of users.

	## Examples

	iex> list_users()
	[%User{}, ...]
	"""
	def list_users do
		Repo.all(User)
	end

	@doc """
	Gets a single user.

	Raises Ecto.NoResultsError if the User does not exist.

	## Examples

	iex> get_user!(123)
	%User{}

	iex> get_user!(456)
	** (Ecto.NoResultsError)
	"""
	def get_user!(id), do: Repo.get!(User, id)

	def get_user(id), do: Repo.get(User, id)

	@doc """
	Creates a user.

	## Examples

	iex> create_user(%{field: value})
	{:ok, %User{}}

	iex> create_user(%{field: bad_value})
	{:error, %Ecto.Changeset{}}
	"""
	def create_user(attrs \\ %{}) do
		%User{}
		|> User.changeset(attrs)
		|> Repo.insert()
	end

	def get_user_by_mail(email) do
		from(
		u in User,
		where: u.email == ^email,
		)
		|> Repo.one()
	end

	@doc """
	Updates a user.

	## Examples

	iex> update_user(user, %{field: new_value})
	{:ok, %User{}}

	iex> update_user(user, %{field: bad_value})
	{:error, %Ecto.Changeset{}}
	"""
	def update_user(%User{} = user, attrs) do
		user
		|> User.changeset(attrs)
		|> Repo.update()
	end

  @doc """
    Get user by username and email
  """
  def get_user_by_email_and_username(email, username) do
    case Repo.get_by(User, email: email, username: username) do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end

	@doc """
	Deletes a user.

	## Examples

	iex> delete_user(user)
	{:ok, %User{}}

	iex> delete_user(user)
	{:error, %Ecto.Changeset{}}
	"""
	def delete_user(%User{} = user) do
		Repo.delete(user)
	end

	@doc """
	Returns an %Ecto.Changeset{} for tracking user changes.

	## Examples

	iex> change_user(user)
	%Ecto.Changeset{data: %User{}}
	"""
	def change_user(%User{} = user, attrs \\ %{}) do
		User.changeset(user, attrs)
	end

	alias Gotham.Gestion.Clock

	@doc """
	Returns the list of clocks.

	## Examples

	iex> list_clocks()
	[%Clock{}, ...]
	"""
	def list_clocks do
		Repo.all(Clock)
	end

	@doc """
	Gets a single clock.

	Raises Ecto.NoResultsError if the Clock does not exist.

	## Examples

	iex> get_clock!(123)
	%Clock{}

	iex> get_clock!(456)
	** (Ecto.NoResultsError)
	"""
	def get_clock!(id), do: Repo.get!(Clock, id)


  def get_all_clock_by_userid(user_id) do
    Clock
    |> where([c], c.user_id == ^user_id)
    |> Repo.all()
  end


	@doc """
	Creates a clock.

	## Examples

	iex> create_clock(%{field: value})
	{:ok, %Clock{}}

	iex> create_clock(%{field: bad_value})
	{:error, %Ecto.Changeset{}}
	"""

  def get_last_clock(user_id) do
    Clock
    |> where([c], c.user_id == ^user_id)
    |> last
    |> Repo.one
  end

	def create_clock(attrs \\ %{}) do
		%Clock{}
		|> Clock.changeset(attrs)
		|> Repo.insert()
	end



	@doc """
	Updates a clock.

	## Examples

	iex> update_clock(clock, %{field: new_value})
	{:ok, %Clock{}}

	iex> update_clock(clock, %{field: bad_value})
	{:error, %Ecto.Changeset{}}
	"""
	def update_clock(%Clock{} = clock, attrs) do
		clock
		|> Clock.changeset(attrs)
		|> Repo.update()
	end

	@doc """
	Deletes a clock.

	## Examples

	iex> delete_clock(clock)
	{:ok, %Clock{}}

	iex> delete_clock(clock)
	{:error, %Ecto.Changeset{}}
	"""
	def delete_clock(%Clock{} = clock) do
		Repo.delete(clock)
	end

	@doc """
	Returns an %Ecto.Changeset{} for tracking clock changes.

	## Examples

	iex> change_clock(clock)
	%Ecto.Changeset{data: %Clock{}}
	"""
	def change_clock(%Clock{} = clock, attrs \\ %{}) do
		Clock.changeset(clock, attrs)
	end

	alias Gotham.Gestion.WorkingTime

	@doc """
	Returns the list of working_times.

	## Examples

	iex> list_working_times()
	[%WorkingTime{}, ...]
	"""
	def list_working_times do
		Repo.all(WorkingTime)
	end

	@doc """
	Gets a single working_time.

	Raises if the Working time does not exist.

	## Examples

	iex> get_working_time!(123)
	%WorkingTime{}
	"""
	def get_working_time!(id), do: Repo.get!(WorkingTime, id)

  def get_all_workingTime_by_userid(user_id, debut, fin) do
    WorkingTime
    |> where([w], w.user_id == ^user_id and w.start >= ^debut and w.end <= ^fin)
    |> Repo.all()
  end

    def get_all_wt(user_id) do
      WorkingTime
      |> where([w], w.user_id == ^user_id)
      |> Repo.all()
    end

  def get_working_time_by_id(user_id,id) do
    WorkingTime
    |> where([w], w.user_id == ^user_id  and w.id == ^id)
    |> Repo.all()
  end

	@doc """
	Creates a working_time.

	## Examples

	iex> create_working_time(%{field: value})
	{:ok, %WorkingTime{}}

	iex> create_working_time(%{field: bad_value})
	{:error, ...}
	"""
	def create_working_time(attrs \\ %{}) do
		%WorkingTime{}
		|> WorkingTime.changeset(attrs)
		|> Repo.insert()
	end

	@doc """
	Updates a working_time.

	## Examples

	iex> update_working_time(working_time, %{field: new_value})
	{:ok, %WorkingTime{}}

	iex> update_working_time(working_time, %{field: bad_value})
	{:error, ...}
	"""
	def update_working_time(%WorkingTime{} = working_time, attrs) do
		working_time
		|> WorkingTime.changeset(attrs)
		|> Repo.update()
	end

	@doc """
	Deletes a WorkingTime.

	## Examples

	iex> delete_working_time(working_time)
	{:ok, %WorkingTime{}}

	iex> delete_working_time(working_time)
	{:error, ...}
	"""
	def delete_working_time(%WorkingTime{} = working_time) do
		Repo.delete(working_time)
	end

	@doc """
	Returns a data structure for tracking working_time changes.

	## Examples

	iex> change_working_time(working_time)
	%Todo{...}
	"""
	def change_working_time(%WorkingTime{} = working_time, attrs \\ %{}) do
		WorkingTime.changeset(working_time, attrs)
	end

	@doc """
	Checks if a user exists by email and username.

	Returns true if the user exists, otherwise false.

	## Examples

	iex> check_user_exists("user@example.com", "john_doe")
	true

	iex> check_user_exists("nonexistent@example.com", "unknown_user")
	false
	"""
	def check_user_exists(email, surname) do
		case Repo.get_by(User, email: email, surname: surname) do
			nil -> false
			_ -> true
		end
	end
end
