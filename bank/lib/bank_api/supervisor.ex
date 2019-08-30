defmodule BankAPI.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    Supervisor.init(
      [
        BankAPI.Projector.Accounts
      ],
      strategy: :one_for_one
    )
  end
end
