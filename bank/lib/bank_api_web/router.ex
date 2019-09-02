defmodule BankAPIWeb.Router do
  use BankAPIWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BankAPIWeb do
    pipe_through :api

    get "/accounts/:id", AccountController, :get

    post "/accounts/create", AccountController, :create

    put "/accounts/:id/deposit", AccountController, :deposit
    put "/accounts/:id/withdraw", AccountController, :withdraw

    put "/accounts/:id/delete", AccountController, :delete

    put "/accounts/:id/transfer", AccountController, :transfer
  end
end
