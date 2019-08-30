defmodule BankAPI.Router do
  use Commanded.Commands.Router

  alias BankAPI.Accounts.Aggregates.Account

  alias BankAPI.Accounts.Commands.{
    OpenAccount,
    CloseAccount,
    DepositIntoAccount,
    WithDrawFromAccount
  }

  middleware(BankAPI.Middleware.ValidateCommand)

  dispatch(
    [
      OpenAccount,
      CloseAccount,
      DepositIntoAccount,
      WithDrawFromAccount
    ],
    to: Account,
    identity: :account_uuid
  )
end
