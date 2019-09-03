defmodule BankAPI.Accounts.Aggregates.Account.Lifespan do
  @behaviour Commanded.Aggregates.AggregateLifespan

  alias BankAPI.Accounts.Events.{
    DepositedIntoAccount,
    WithdrawnFromAccount,
    AccountClosed
  }

  alias BankAPI.Accounts.Commands.CloseAccount

  def after_event(%DepositedIntoAccount{}), do: :timer.hours(1)
  def after_event(%WithdrawnFromAccount{}), do: :timer.hours(1)
  def after_event(%AccountClosed{}), do: :stop
  def after_event(_event), do: :infinity

  def after_command(%CloseAccount{}), do: :stop
  def after_command(_command), do: :infinity

  def after_error(:invalid_initial_balance), do: :timer.minutes(5)
  def after_error(_error), do: :stop
end
