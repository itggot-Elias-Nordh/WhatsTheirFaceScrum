defmodule Pluggy.WTFController do

  require IEx

  alias Pluggy.Students
  alias Pluggy.Classes
  alias Pluggy.User
  import Pluggy.Template, only: [render: 2]
  import Plug.Conn, only: [send_resp: 3]


  def index(conn) do
    send_resp(conn, 200, render("whatsTheirFace/index", []))
  end

  def login(conn) do
    send_resp(conn, 200, render("whatsTheirFace/login", []))
  end

  def difficulty(conn) do
    classes = Classes.all
    send_resp(conn, 200, render("whatsTheirFace/difficulty", classes: classes))
  end

  def quiz1(conn) do
    conn = Plug.Conn.put_session(conn, :times, conn.private.plug_session["times"] + 1)
    if conn.private.plug_session["start"] == nil or conn.private.plug_session["start"] == false do
      redirect(conn, "/home")
    end
    className = conn.private.plug_session["className"]
    difficulty = conn.private.plug_session["difficulty"]
    class = Classes.get_id_by_name(className)
    students = Enum.shuffle(Students.get_by_class_id(Integer.to_string(class.id)))
    students = case difficulty do
      "2" -> students
      "1" -> divide_list(students, 2)
      _   -> divide_list(students, 4)
    end
    send_resp(conn, 200, render("whatsTheirFace/quiz1", students: students, className: className))
  end

  def divide_list(a, divider) do
    length = length(a)
    remove_length = length - round(length/divider)
    subtract_list(a, remove_length)
  end

  def subtract_list(a, remove_length) when remove_length == 0, do: a

  def subtract_list([_ | tail], remove_length), do: subtract_list(tail, remove_length - 1)

#   get('/game1') do
#     session[:times] += 1
#     if session[:start] == nil or session[:start] == false
#         redirect('/')
#     end
#     className = session[:className]
#     difficulty = session[:difficulty].to_i
#     names = getList()[0][className].shuffle
#     if difficulty == 2
#     elsif difficulty == 1
#         size = (names.length/2).to_i
#         names = names[0...size]
#     else
#         size = (names.length/4).to_i
#         names = names[0...size]
#     end
#     if names.length < 4
#         session[:error] = "Too few students"
#   session[:back] = "/"
#   halt 404
#     end
#     if session[:times] > 1
#         session[:error] = "You are not allowed to view this page"
#         if session[:times] > names.length
#             session[:back] = "/score"
#         else
#             session[:cheat] += 1
#             session[:times] = session[:times] - 2
#             session[:back] = "/game2/#{session[:times] - 1}"
#         end
#         halt 404
#     end
#     session[:names] = names.shuffle
#     slim(:game1, locals:{className: className, names: names})
# end

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
    session_user = conn.private.plug_session["user_id"]
    current_user = case session_user do
      nil -> nil
      _   -> Pluggy.User.get_by_id(session_user)
    end

    send_resp(conn, 200, render("whatsTheirFace/home", []))
  end

  defp redirect(conn, url) do
    Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
  end

end