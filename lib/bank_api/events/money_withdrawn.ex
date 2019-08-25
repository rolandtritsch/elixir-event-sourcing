defmodule BankAPI.Event.MoneyWithdrawn do
  @derive Jason.Encoder
  defstruct [:transfer_uuid]
end
