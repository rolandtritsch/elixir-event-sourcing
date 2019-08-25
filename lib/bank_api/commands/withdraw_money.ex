defmodule BankAPI.Command.WithdrawMoney do
  @enforce_keys [:account_number]
  defstruct [:account_number, :transfer_uuid, :amount]
end
