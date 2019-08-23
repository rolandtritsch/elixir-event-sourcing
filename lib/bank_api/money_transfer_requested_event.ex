defmodule MoneyTransferRequested do
  @derive Jason.Encoder
  defstruct [:transfer_uuid, :debit_account, :credit_account, :amount]
end
