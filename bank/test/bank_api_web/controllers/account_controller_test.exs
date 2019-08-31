defmodule BankAPIWeb.AccountControllerTest do
  use BankAPIWeb.ConnCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create account" do
    test "renders account when data is valid", %{conn: conn} do
      conn =
        post(
          conn,
          Routes.account_path(conn, :create, initial_balance: 10_000)
        )

      assert %{
               "uuid" => _uuid,
               "current_balance" => 10_000
             } = json_response(conn, 200)["data"]
    end
  end

  @tag :skip
  describe "deposit" do
    test "small amount", %{conn: conn} do
      conn =
        post(
          conn,
          Routes.account_path(conn, :create, initial_balance: 42)
        )

      %{"uuid" => id, "current_balance" => balance} = json_response(conn, 200)["data"]
      assert balance === 42

      conn =
        get(
          conn,
          Routes.account_path(conn, :get, id)
        )

      %{"uuid" => id_, "current_balance" => balance} = json_response(conn, 200)["data"]
      assert id === id_
      assert balance === 42
    end
  end
end
