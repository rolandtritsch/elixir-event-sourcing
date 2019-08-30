defmodule BankAPI.Accounts.Commands.DepositIntoAccount do
  @enforce_keys [:account_uuid]

  defstruct [
    :account_uuid,
    :deposit_amount
  ]

  alias BankAPI.Accounts
  alias BankAPI.Accounts.Commands.Validators

  def valid?(command) do
    Skooma.valid?(Map.from_struct(command), schema())
  end

  defp schema do
    %{
      account_uuid: [:string, Skooma.Validators.regex(Accounts.uuid_regex())],
      deposit_amount: [:int, &Validators.positive_integer(&1, 1)]
    }
  end
end
