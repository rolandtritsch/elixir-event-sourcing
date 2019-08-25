defmodule BankAPI.Event.MoneyDeposited do
  @derive Jason.Encoder
  defstruct [:transfer_uuid]
end
