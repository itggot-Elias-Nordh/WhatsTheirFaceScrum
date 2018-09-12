defmodule Pluggy.Router do
  use Plug.Router

  alias Pluggy.FruitController
  alias Pluggy.WTFController
  alias Pluggy.UserController
  alias Pluggy.ClassController
  alias Pluggy.StudentController

  plug Plug.Static, at: "/", from: :pluggy
  plug(:put_secret_key_base)

  plug(Plug.Session,
    store: :cookie,
    key: "_pluggy_session",
    encryption_salt: "cookie store encryption salt",
    signing_salt: "cookie store signing salt",
    key_length: 64,
    log: :debug,
    secret_key_base: "-- LONG STRING WITH AT LEAST 64 BYTES --"
  )

  plug(:fetch_session)
  plug(Plug.Parsers, parsers: [:urlencoded, :multipart])
  plug(:match)
  plug(:dispatch)



  get "/",                      do: WTFController.index(conn)
  get "/login",                 do: UserController.login(conn)
  post "/login",                do: UserController.login(conn, conn.body_params)
  post "/logout",               do: UserController.logout(conn)

  get "/home",                  do: UserController.home(conn)
  get "/classes",               do: ClassController.index(conn)
  get "/classes/new",           do: ClassController.new (conn)
  get "/classes/:id",           do: ClassController.show(conn, id)
  get "/classes/:id/edit",      do: ClassController.edit(conn, id)
  post "/classes/new",          do: ClassController.create(conn, conn.body_params)
  post "/classes/:id/edit",     do: ClassController.update(conn, id, conn.body_params)
  post "/classes/:id/destroy",  do: ClassController.destroy(conn, id)

  get "/students/new",           do: StudentController.new (conn)
  get "/students/:id",           do: StudentController.show(conn, id)
  get "/students/:id/edit",      do: StudentController.edit(conn, id)
  post "/students/new",          do: StudentController.create(conn, conn.body_params)
  post "/students/:id/edit",     do: StudentController.update(conn, id, conn.body_params)
  post "/students/:id/destroy",  do: StudentController.destroy(conn, id)


  match _ do
    send_resp(conn, 404, "oops")
  end

  defp put_secret_key_base(conn, _) do
    put_in(
      conn.secret_key_base,
      "-- LONG STRING WITH AT LEAST 64 BYTES LONG STRING WITH AT LEAST 64 BYTES --"
    )
  end
end
