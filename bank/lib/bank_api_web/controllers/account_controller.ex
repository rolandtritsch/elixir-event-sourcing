defmodule BankAPIWeb.AccountController do
  use BankAPIWeb, :controller

  alias BankAPI.Accounts
  alias BankAPI.Accounts.Projections.Account

  action_fallback BankAPIWeb.FallbackController

  def create(conn, %{"initial_balance" => balance}) do
    with {b, ""} <- Integer.parse(balance),
         {:ok, %Account{} = account} <- Accounts.open(b) do
      conn
      |> put_status(:ok)
      |> render("show.json", account: account)
    end
  end

  def get(conn, %{"id" => id}) do
    with {:ok, %Account{} = account} <- Accounts.get(id) do
      conn
      |> put_status(:ok)
      |> render("show.json", account: account)
    end
  end

  def deposit(conn, %{"id" => id, "amount" => amount}) do
    with {a, ""} <- Integer.parse(amount),
         {:ok, %Account{} = account} <- Accounts.deposit(id, a) do
      conn
      |> put_status(:ok)
      |> render("show.json", account: account)
    end
  end

  def withdraw(conn, %{"id" => id, "amount" => amount}) do
    with {a, ""} <- Integer.parse(amount),
         {:ok, %Account{} = account} <- Accounts.withdraw(id, a) do
      conn
      |> put_status(:ok)
      |> render("show.json", account: account)
    end
  end

  def transfer(conn, %{"id" => id, "to_id" => to_id, "amount" => amount}) do
    with {a, ""} <- Integer.parse(amount),
         :ok <- Accounts.transfer(id, to_id, a) do
      conn
      |> put_status(:ok)
      |> json(%{data: %{from: id, to: to_id, amount: a, transfered: :ok}})
    end
  end

  def delete(conn, %{"id" => id}) do
    with :ok <- Accounts.close(id) do
      conn
      |> put_status(:ok)
      |> json(%{data: %{id: id, deleted: :ok}})
    end
  end
end
