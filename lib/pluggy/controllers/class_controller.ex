defmodule Pluggy.ClassController do

  require IEx

  alias Pluggy.Classes
  alias Pluggy.Students
  alias Pluggy.User
  import Pluggy.Template, only: [render: 2]
  import Plug.Conn, only: [send_resp: 3]


  def index(conn) do
    send_resp(conn, 200, render("whatsTheirFace/classes", classes: Classes.all()))
  end

  def show(conn, id) do
    send_resp(conn, 200, render("whatsTheirFace/class", class: Classes.get_by_id(id), students: Students.get_by_class_id(id)))
  end

  def new(conn),          do: send_resp(conn, 200, render("whatsTheirFace/classes_new", []))
  def edit(conn, id),     do: send_resp(conn, 200, render("whatsTheirFace/classes_edit", class: Classes.get_by_id(id), students: Students.get_by_class_id(id)))

  def create(conn, params) do

    Classes.create(params)
    redirect(conn, "/classes")
  end

  def update(conn, id, params) do
    Classes.update(id, params)
    redirect(conn, "/classes")
  end

  def destroy(conn, id) do
    Classes.delete(id)
    redirect(conn, "/classes")
  end

  defp redirect(conn, url) do
    Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
  end

end
