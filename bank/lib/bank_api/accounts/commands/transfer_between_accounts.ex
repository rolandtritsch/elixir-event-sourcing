defmodule BankAPI.Accounts.Commands.TransferBetweenAccounts do
  @enforce_keys [
    :account_uuid,
    :transfer_uuid
  ]

  defstruct [
    :account_uuid,
    :to_uuid,
    :amount,
    :transfer_uuid
  ]

  alias BankAPI.Repo
  alias BankAPI.Accounts
  alias BankAPI.Accounts.Commands.Validators
  alias BankAPI.Accounts.Projections.Account

  def valid?(command) do
    cmd = Map.from_struct(command)

    with %Account{} <- account_exists?(cmd.to_uuid),
         true <- account_open?(cmd.to_uuid) do
      Skooma.valid?(cmd, schema())
    else
      nil ->
        {:error, ["Destination account does not exist"]}

      false ->
        {:error, ["Destination account closed"]}

      reply ->
        reply
    end
  end

  defp schema do
    %{
      account_uuid: [:string, Skooma.Validators.regex(Accounts.uuid_regex())],
      to_uuid: [:string, Skooma.Validators.regex(Accounts.uuid_regex())],
      amount: [:int, &Validators.positive_integer(&1, 1)],
      transfer_uuid: [:string, Skooma.Validators.regex(Accounts.uuid_regex())]
    }
  end

  defp account_exists?(uuid) do
    Repo.get(Account, uuid)
  end

  defp account_open?(uuid) do
    account = Repo.get!(Account, uuid)
    account.status == Account.status().open
  end
end
