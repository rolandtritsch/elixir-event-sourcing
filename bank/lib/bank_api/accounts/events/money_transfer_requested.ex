defmodule BankAPI.Accounts.Events.MoneyTransferRequested do
  @derive [Jason.Encoder]

  defstruct [
    :account_uuid,
    :to_uuid,
    :amount,
    :transfer_uuid
  ]
end
