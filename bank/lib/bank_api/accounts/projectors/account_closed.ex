defmodule BankAPI.Accounts.Projectors.AccountClosed do
  use Commanded.Projections.Ecto,
    name: "Accounts.Projectors.AccountClosed"

  alias BankAPI.Accounts
  alias BankAPI.Accounts.Events.AccountClosed
  alias BankAPI.Accounts.Projections.Account
  alias Ecto.{Changeset, Multi}

  project(%AccountClosed{} = event, _metadata, fn multi ->
    with {:ok, %Account{} = account} <- Accounts.get(event.account_uuid) do
      Multi.update(
        multi,
        :account,
        Changeset.change(account, status: Account.status().closed)
      )
    else
      # ignore when this happens
      _ -> multi
    end
  end)
end
