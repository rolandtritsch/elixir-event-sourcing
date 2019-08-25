defmodule BankAPI.Router.Bank do
  use Commanded.Commands.Router

  alias BankAPI.Command.OpenAccount
  alias BankAPI.Aggregate.BankAccount

  dispatch(OpenAccount, to: BankAccount, identity: :account_number)
end
