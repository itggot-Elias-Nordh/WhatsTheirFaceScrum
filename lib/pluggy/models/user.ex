defmodule Pluggy.User do

	defstruct(id: nil, name: "", username: "", password: "")

	alias Pluggy.User


	def get_by_id(id) do
		Postgrex.query!(DB, "SELECT * FROM users WHERE id = $1 LIMIT 1", [id], pool: DBConnection.Poolboy).rows |> to_struct
	end

  def get_by_username(username) do
    Postgrex.query!(DB, "SELECT * FROM users WHERE username = $1 LIMIT 1", [username], pool: DBConnection.Poolboy).rows |> to_struct
  end

	def to_struct([[id, name, username, password]]) do
		%User{id: id, name: name, username: username, password: password}
	end
end