defmodule BankAPI.Command.OpenAccount do
  @enforce_keys [:account_number]
  defstruct [:account_number, :initial_balance]
end
