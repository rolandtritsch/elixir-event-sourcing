defmodule BankAPI.Accounts.Process.TransferMoney do
  use Commanded.ProcessManagers.ProcessManager,
    name: "Accounts.Process.TransferMoney",
    router: BankAPI.Router

  alias __MODULE__

  alias BankAPI.Accounts.Commands.{
    WithdrawFromAccount,
    DepositIntoAccount
  }

  alias BankAPI.Accounts.Events.{
    MoneyTransferRequested,
    WithdrawnFromAccount,
    DepositedIntoAccount
  }

  @derive Jason.Encoder

  defstruct [
    :account_uuid,
    :to_uuid,
    :amount,
    :transfer_uuid,
    :status
  ]

  def interested?(%MoneyTransferRequested{transfer_uuid: transfer_uuid}),
    do: {:start!, transfer_uuid}

  def interested?(%WithdrawnFromAccount{transfer_uuid: transfer_uuid})
      when is_nil(transfer_uuid),
      do: false

  def interested?(%WithdrawnFromAccount{transfer_uuid: transfer_uuid}),
    do: {:continue!, transfer_uuid}

  def interested?(%DepositedIntoAccount{transfer_uuid: transfer_uuid})
      when is_nil(transfer_uuid),
      do: false

  def interested?(%DepositedIntoAccount{transfer_uuid: transfer_uuid}),
    do: {:stop, transfer_uuid}

  def interested?(_event), do: false

  # ---

  def handle(
        %TransferMoney{},
        %MoneyTransferRequested{
          account_uuid: account_uuid,
          amount: amount,
          transfer_uuid: transfer_uuid
        }
      ) do
    %WithdrawFromAccount{
      account_uuid: account_uuid,
      amount: amount,
      transfer_uuid: transfer_uuid
    }
  end

  def handle(
        %TransferMoney{
          account_uuid: _account_uuid,
          to_uuid: to_uuid,
          amount: amount,
          transfer_uuid: transfer_uuid
        },
        %WithdrawnFromAccount{}
      ) do
    %DepositIntoAccount{
      account_uuid: to_uuid,
      amount: amount,
      transfer_uuid: transfer_uuid
    }
  end

  # ---

  def apply(%TransferMoney{} = pm, %MoneyTransferRequested{} = event) do
    %TransferMoney{
      pm
      | account_uuid: event.account_uuid,
        to_uuid: event.to_uuid,
        amount: event.amount,
        transfer_uuid: event.transfer_uuid,
        status: :withdraw_money_from_account
    }
  end

  def apply(%TransferMoney{} = pm, %WithdrawnFromAccount{}) do
    %TransferMoney{
      pm
      | status: :deposit_money_in_account
    }
  end
end
