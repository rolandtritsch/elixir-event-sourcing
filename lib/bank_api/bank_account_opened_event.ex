defmodule BankAccountOpened do
  @derive Jason.Encoder
  defstruct [:account_number, :initial_balance]
end
