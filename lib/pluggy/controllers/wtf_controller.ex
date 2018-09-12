defmodule Pluggy.WTFController do

  require IEx

  alias Pluggy.Students
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
    session_user = conn.private.plug_session["user_id"]
    current_user = case session_user do
      nil -> nil
      _   -> Pluggy.User.get_by_id(session_user)
    end

    send_resp(conn, 200, render("whatsTheirFace/home", user: current_user))
  end

  def difficulty(conn) do
    send_resp(conn, 200, render("whatsTheirFace/difficulty", []))
  end

  def quiz1(conn) do
    conn = Plug.Conn.put_session(conn, :times, conn.private.plug_session["times"] + 1)
    if conn.private.plug_session["start"] == nil or conn.private.plug_session["start"] == false do
        redirect(conn, "/wtf")
    end
    className = conn.private.plug_session["className"]
    difficulty = conn.private.plug_session["difficulty"]
    send_resp(conn, 200, render("whatsTheirFace/quiz1", className: className))
  end

  def quiz_start(conn, params) do
    conn = Plug.Conn.put_session(conn, :start, true)
    conn = Plug.Conn.put_session(conn, :times, 0)
    conn = Plug.Conn.put_session(conn, :cheat, 0)
    conn = Plug.Conn.put_session(conn, :className, params["className"])
    conn = Plug.Conn.put_session(conn, :difficulty, params["difficulty"])
    conn = Plug.Conn.put_session(conn, :score, true)
    redirect(conn, "/quiz1")
  end  

  def home(conn) do

    #get user if logged in
    session_user = conn.private.plug_session["user_id"]
    current_user = case session_user do
      nil -> nil
      _   -> User.get_by_id(session_user)
    end

    send_resp(conn, 200, render("whatsTheirFace/home", []))
  end

  defp redirect(conn, url) do
    Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
  end

end