defmodule Pluggy.UserController do

	import Pluggy.Template, only: [render: 2]
	import Plug.Conn, only: [send_resp: 3]

	def login(conn, params) do
		username = params["username"]
		password = params["pwd"]

		result = Pluggy.User.get_by_username(username)

		case result.id do
		  nil -> #no user with that username
		    redirect(conn, "/home")
		  _ -> #user with that username exists
		    #make sure password is correct
		    if Bcrypt.verify_pass(password, result.password) do
		      Plug.Conn.put_session(conn, :user_id, result.id)
		      |>redirect("/home")
		    else
		      redirect(conn, "/wrong")
		    end
		end
	end

	def logout(conn) do
		Plug.Conn.configure_session(conn, drop: true)
		|> redirect("/")
	end

  def home(conn) do
    session_user = conn.private.plug_session["user_id"]
    current_user = case session_user do
      nil -> nil
      _   -> Pluggy.User.get_by_id(session_user)
    end

    send_resp(conn, 200, render("whatsTheirFace/home", user: current_user))
  end

  def register(conn) do
    session_user = conn.private.plug_session["user_id"]
    reg = case session_user do
      nil -> send_resp(conn, 200, render("whatsTheirFace/register", []))
      _   -> redirect(conn, "/home")
    end
  end

  def register(conn, params) do
    Pluggy.User.create(params)
    redirect(conn ,"/login")
  end

	# def create(conn, params) do
	# 	#pseudocode
	# 	# in db table users with password_hash CHAR(60)
	# 	# hashed_password = Bcrypt.hash_pwd_salt(params["password"])
    #  	# Postgrex.query!(DB, "INSERT INTO users (username, password_hash) VALUES ($1, $2)", [params["username"], hashed_password], [pool: DBConnection.Poolboy])
    #  	# redirect(conn, "/fruits")
	# end

	defp redirect(conn, url), do: Plug.Conn.put_resp_header(conn, "location", url) |> send_resp(303, "")
end
