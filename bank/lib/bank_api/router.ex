defmodule BankAPI.Router do
  use Commanded.Commands.Router

  alias BankAPI.Accounts.Aggregates.Account

  alias BankAPI.Accounts.Commands.{
    OpenAccount,
    CloseAccount,
    DepositIntoAccount,
    WithdrawFromAccount,
    TransferBetweenAccounts
  }

  middleware(BankAPI.Middleware.ValidateCommand)

  dispatch [OpenAccount,CloseAccount],
    to: Account,
    identity: :account_uuid,
    lifespan: Account.Lifespan

  dispatch [
      DepositIntoAccount,
      WithdrawFromAccount,
      TransferBetweenAccounts
    ],
    to: Account,
    identity: :account_uuid
end
