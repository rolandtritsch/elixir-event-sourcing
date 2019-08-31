defmodule BankAPI.Accounts.Projectors.AccountOpened do
  use Commanded.Projections.Ecto,
    name: "Accounts.Projectors.AccountOpened",
    consistency: :strong

  alias BankAPI.Accounts.Events.AccountOpened
  alias BankAPI.Accounts.Projections.Account

  project(%AccountOpened{} = event, _metadata, fn multi ->
    Ecto.Multi.insert(multi, :account_opened, %Account{
      uuid: event.account_uuid,
      current_balance: event.initial_balance,
      status: "open"
    })
  end)
end
