defmodule Bank.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    Supervisor.init(
      [
        AccountsProjector
      ],
      strategy: :one_for_one
    )
  end
end
