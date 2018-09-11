defmodule Pluggy.Classes do

  defstruct(id: nil, name: "")

  def all do
    Postgrex.query!(DB, "SELECT * FROM classes", [], [pool: DBConnection.Poolboy]).rows
    |> to_struct_list
  end

  def get_by_id(id) do
    Postgrex.query!(DB, "SELECT * FROM classes WHERE id = $1 LIMIT 1", [String.to_integer(id)], [pool: DBConnection.Poolboy]).rows
    |> to_struct
  end

  def update(id, params) do
    name = params["name"]
    id = String.to_integer(id)
    Postgrex.query!(DB, "UPDATE classes SET name = $1, WHERE id = $2", [name, id], [pool: DBConnection.Poolboy])
  end

  def create(params) do
    name = params["name"]
    Postgrex.query!(DB, "INSERT INTO classes (name) VALUES ($1)", [name], [pool: DBConnection.Poolboy])
  end

  def delete_by_id(id) do
    Postgrex.query!(DB, "DELETE FROM classes WHERE id = $1", [String.to_integer(id)], [pool: DBConnection.Poolboy])
  end

  def to_struct([[id, name, tastiness]]) do
    %Pluggy.Students{id: id, name: name}
  end

  def to_struct_list(rows) do
    for [id, name] <- rows, do: %Pluggy.Classes{id: id, name: name}
  end
end