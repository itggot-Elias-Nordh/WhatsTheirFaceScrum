defmodule Pluggy.Students do
	
	defstruct(id: nil, name: "", img_path: "", class_id: 0)

	def all do
		Postgrex.query!(DB, "SELECT * FROM students", [], [pool: DBConnection.Poolboy]).rows
		|> to_struct_list
	end

	def get_by_id(id) do
		Postgrex.query!(DB, "SELECT * FROM students WHERE id = $1 LIMIT 1", [String.to_integer(id)], [pool: DBConnection.Poolboy]).rows
		|> to_struct
	end

	def update(id, params) do
		name = params["name"]
		class_id = params["class_id"]
		id = String.to_integer(id)
		Postgrex.query!(DB, "UPDATE students SET name = $1, class_id = $2 WHERE id = $3", [name, class_id, id], [pool: DBConnection.Poolboy])
	end

	def create(params) do
		name = params["name"]
		img_path = String.to_integer(params["img_path"])
		class_id = String.to_integer(params["class_id"])
		Postgrex.query!(DB, "INSERT INTO students (name, class_id, img_path) VALUES ($1, $2, $3)", [name, class_id, img_path], [pool: DBConnection.Poolboy])
	end

	def delete_by_id(id) do
		Postgrex.query!(DB, "DELETE FROM students WHERE id = $1", [String.to_integer(id)], [pool: DBConnection.Poolboy])
	end

	def to_struct([[id, name, img_path, class_id]]) do
		%Pluggy.Students{id: id, name: name, img_path: img_path, class_id: class_id}
	end

	def to_struct_list(rows) do
		for [id, name, img_path, class_id] <- rows, do: %Pluggy.Students{id: id, name: name, img_path: img_path, class_id: class_id}
	end
end