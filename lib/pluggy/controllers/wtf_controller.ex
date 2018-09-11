defmodule Pluggy.WTFController do

  require IEx

  alias Pluggy.Wtf
  alias Pluggy.User
  import Pluggy.Template, only: [render: 2]
  import Plug.Conn, only: [send_resp: 3]


  def index(conn) do
    send_resp(conn, 200, render("whatsTheirFace/index", []))
  end

  def login(conn) do
    send_resp(conn, 200, render("whatsTheirFace/login", []))
  end

  def home(conn) do

    #get user if logged in
    session_user = conn.private.plug_session["user_id"]
    current_user = case session_user do
      nil -> nil
      _   -> User.get(session_user)
    end

    send_resp(conn, 200, render("whatsTheirFace/home", wtf: Students.all(), user: current_user))
  end

  defp redirect(conn, url) do
    Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
  end

end