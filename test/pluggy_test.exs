defmodule PluggyTest do
  use ExUnit.Case
  doctest Pluggy

  test "greets the world" do
    resp = Postgrex.query!(DB, "SELECT * FROM users WHERE username = $1 LIMIT 1", ["erik.landmark"], pool: DBConnection.Poolboy).rows |> Pluggy.User.to_struct |> IO.inspect
    assert resp != nil
  end
end
