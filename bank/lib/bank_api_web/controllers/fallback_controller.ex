defmodule BankAPIWeb.FallbackController do
  use BankAPIWeb, :controller

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(BankAPIWeb.ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, :bad_command}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(BankAPIWeb.ErrorView)
    |> render(:"422")
  end

  def call(conn, {:error, :command_validation_failure, _command, _errors}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(BankAPIWeb.ErrorView)
    |> render(:"422")
  end

  def call(conn, _) do
    conn
    |> put_status(:no_match)
    |> put_view(BankAPIWeb.ErrorView)
    |> render(:"422")
  end
end
