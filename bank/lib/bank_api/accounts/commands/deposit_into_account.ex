defmodule BankAPI.Accounts.Commands.DepositIntoAccount do
  @enforce_keys [:account_uuid]

  defstruct [
    :account_uuid,
    :amount,
    :transfer_uuid
  ]

  alias BankAPI.Accounts
  alias BankAPI.Accounts.Commands.Validators

  def valid?(command) do
    Skooma.valid?(Map.from_struct(command), schema())
  end

  defp schema do
    %{
      account_uuid: [:string, Skooma.Validators.regex(Accounts.uuid_regex())],
      amount: [:int, &Validators.positive_integer(&1, 1)],
      transfer_uuid: [:string, Skooma.Validators.regex(Accounts.uuid_regex())]
    }
  end
end
