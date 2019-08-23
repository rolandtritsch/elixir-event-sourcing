defmodule TransferMoneyProcessManager do
  use Commanded.ProcessManagers.ProcessManager,
    name: "TransferMoneyProcessManager",
    router: BankRouter

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

  def handle(%TransferMoneyProcessManager{}, %MoneyTransferRequested{} = event) do
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

  def handle(%TransferMoneyProcessManager{} = pm, %MoneyWithdrawn{}) do
    %TransferMoneyProcessManager{
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
    %TransferMoneyProcessManager{} = transfer,
    %MoneyTransferRequested{} = event
  ) do
    %MoneyTransferRequested{
      transfer_uuid: transfer_uuid,
      debit_account: debit_account,
      credit_account: credit_account,
      amount: amount
    } = event

    %TransferMoneyProcessManager{transfer |
      transfer_uuid: transfer_uuid,
      debit_account: debit_account,
      credit_account: credit_account,
      amount: amount,
      status: :withdraw_money_from_debit_account
    }
  end

  def apply(%TransferMoneyProcessManager{} = transfer, %MoneyWithdrawn{}) do
    %TransferMoneyProcessManager{transfer |
      status: :deposit_money_in_credit_account
    }
  end
end
