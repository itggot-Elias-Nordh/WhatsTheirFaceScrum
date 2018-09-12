defmodule Pluggy.StudentController do

  require IEx

  alias Pluggy.Student
  alias Pluggy.User

  import Pluggy.Template, only: [render: 2]
  import Plug.Conn, only: [send_resp: 3]


  def index(conn) do
    send_resp(conn, 200, render("whatsTheirFace/students", classes: Classes.all()))
  end

  def new(conn),          do: send_resp(conn, 200, render("whatsTheirFace/students_new", []))
  def edit(conn, id),     do: send_resp(conn, 200, render("whatsTheirFace/students_edit", fruit: Fruit.get(id)))

  def create(conn, params) do
    Student.create(params)
    redirect(conn, "/classes")
  end

  def update(conn, id, params) do
    Student.update(id, params)
    redirect(conn, "/classes")
  end

  def destroy(conn, id) do
    Student.delete(id)
    redirect(conn, "/classes")
  end

  defp redirect(conn, url) do
    Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
  end

end
