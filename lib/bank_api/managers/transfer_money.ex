defmodule BankAPI.Manager.TransferMoney do
  use Commanded.ProcessManagers.ProcessManager,
    name: "TransferMoney",
    router: BankRouter

  alias BankAPI.Manager.TransferMoney

  alias BankAPI.Event.MoneyTransferRequested
  alias BankAPI.Event.MoneyWithdrawn
  alias BankAPI.Event.MoneyDeposited

  alias BankAPI.Command.WithdrawMoney
  alias BankAPI.Command.DepositMoney

  @derive Jason.Encoder
  defstruct [
    :transfer_uuid,
    :debit_account,
    :credit_account,
    :amount,
    :status
  ]

  # Process routing

  def interested?(
    %MoneyTransferRequested{transfer_uuid: transfer_uuid}
  ), do: {:start, transfer_uuid}
  def interested?(
    %MoneyWithdrawn{transfer_uuid: transfer_uuid}
  ), do: {:continue, transfer_uuid}
  def interested?(
    %MoneyDeposited{transfer_uuid: transfer_uuid}
  ), do: {:stop, transfer_uuid}
  def interested?(_event), do: false

  # Command dispatch

  def handle(%TransferMoney{}, %MoneyTransferRequested{} = event) do
    %MoneyTransferRequested{
      transfer_uuid: transfer_uuid,
      debit_account: debit_account,
      amount: amount
    } = event

    %WithdrawMoney{
      account_number: debit_account,
      transfer_uuid: transfer_uuid,
      amount: amount
    }
  end

  def handle(%TransferMoney{} = pm, %MoneyWithdrawn{}) do
    %TransferMoney{
      transfer_uuid: transfer_uuid,
      credit_account: credit_account,
      amount: amount
    } = pm

    %DepositMoney{
      account_number: credit_account,
      transfer_uuid: transfer_uuid,
      amount: amount
    }
  end

  # State mutators

  def apply(
    %TransferMoney{} = transfer,
    %MoneyTransferRequested{} = event
  ) do
    %MoneyTransferRequested{
      transfer_uuid: transfer_uuid,
      debit_account: debit_account,
      credit_account: credit_account,
      amount: amount
    } = event

    %TransferMoney{transfer |
      transfer_uuid: transfer_uuid,
      debit_account: debit_account,
      credit_account: credit_account,
      amount: amount,
      status: :withdraw_money_from_debit_account
    }
  end

  def apply(%TransferMoney{} = transfer, %MoneyWithdrawn{}) do
    %TransferMoney{transfer |
      status: :deposit_money_in_credit_account
    }
  end
end
