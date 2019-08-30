defmodule BankAPI.Accounts.Supervisor do
  use Supervisor

  alias BankAPI.Accounts

  def start_link do
    Supervisor.start_link(__MODULE__, nil)
  end

  def init(_arg) do
    children = [
      worker(Accounts.Projectors.AccountOpened, [], id: :account_opened),
      worker(Accounts.Projectors.AccountClosed, [], id: :account_closed),
      worker(Accounts.Projectors.DepositsAndWithdrawals, [], id: :deposits_and_withdrawals)
    ]

    supervise(children, strategy: :one_for_one)
  end
end
