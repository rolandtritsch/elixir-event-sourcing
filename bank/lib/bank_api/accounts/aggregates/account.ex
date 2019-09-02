defmodule BankAPI.Accounts.Aggregates.Account do
  defstruct [
    account_uuid: nil,
    current_balance: nil,
    closed?: false
  ]

  alias __MODULE__

  alias BankAPI.Accounts.Commands.{
    OpenAccount,
    CloseAccount,
    DepositIntoAccount,
    WithdrawFromAccount,
    TransferBetweenAccounts
  }

  alias BankAPI.Accounts.Events.{
    AccountOpened,
    AccountClosed,
    DepositedIntoAccount,
    WithdrawnFromAccount,
    MoneyTransferRequested
  }

  # ---

  def execute(
        %Account{account_uuid: nil},
        %OpenAccount{
          account_uuid: account_uuid,
          initial_balance: initial_balance
        }
      )
      when initial_balance > 0 do
    %AccountOpened{
      account_uuid: account_uuid,
      initial_balance: initial_balance
    }
  end

  def execute(
        %Account{account_uuid: nil},
        %OpenAccount{
          initial_balance: initial_balance
        }
      )
      when initial_balance <= 0 do
    {:error, :initial_balance_must_be_above_zero}
  end

  def execute(%Account{}, %OpenAccount{}) do
    {:error, :account_already_opened}
  end

  # ---

  def execute(
        %Account{account_uuid: account_uuid, closed?: false, current_balance: current_balance},
        %DepositIntoAccount{account_uuid: account_uuid, amount: amount}
      ) do
    %DepositedIntoAccount{
      account_uuid: account_uuid,
      new_current_balance: current_balance + amount
    }
  end

  def execute(
        %Account{account_uuid: account_uuid, closed?: true},
        %DepositIntoAccount{account_uuid: account_uuid}
      ) do
    {:error, :account_closed}
  end

  def execute(
        %Account{},
        %DepositIntoAccount{}
      ) do
    {:error, :not_found}
  end

  # ---

  def execute(
        %Account{account_uuid: account_uuid, closed?: false, current_balance: current_balance},
        %WithdrawFromAccount{account_uuid: account_uuid, amount: amount}
      ) do
    if current_balance - amount >= 0 do
      %WithdrawnFromAccount{
        account_uuid: account_uuid,
        new_current_balance: current_balance - amount
      }
    else
      {:error, :insufficient_funds}
    end
  end

  def execute(
        %Account{account_uuid: account_uuid, closed?: true},
        %WithdrawFromAccount{account_uuid: account_uuid}
      ) do
    {:error, :account_closed}
  end

  def execute(
        %Account{},
        %WithdrawFromAccount{}
      ) do
    {:error, :not_found}
  end

  # ---

  def execute(
        %Account{account_uuid: account_uuid, closed?: false},
        %CloseAccount{
          account_uuid: account_uuid
        }
      ) do
    %AccountClosed{
      account_uuid: account_uuid
    }
  end

  def execute(
        %Account{account_uuid: account_uuid, closed?: true},
        %CloseAccount{
          account_uuid: account_uuid
        }
      ) do
    {:error, :account_already_closed}
  end

  def execute(
        %Account{},
        %CloseAccount{}
      ) do
    {:error, :not_found}
  end

  # ---

  def execute(
        %Account{account_uuid: account_uuid, closed?: true},
        %TransferBetweenAccounts{account_uuid: account_uuid}
      ) do
    {:error, :account_closed}
  end

  def execute(
        %Account{account_uuid: account_uuid, closed?: false},
        %TransferBetweenAccounts{
          account_uuid: account_uuid,
          to_uuid: to_uuid
        }
      )
      when account_uuid == to_uuid do
    {:error, :transfer_to_same_account}
  end

  def execute(
        %Account{
          account_uuid: account_uuid,
          closed?: false,
          current_balance: current_balance
        },
        %TransferBetweenAccounts{
          account_uuid: account_uuid,
          amount: amount
        }
      )
      when current_balance < amount do
    {:error, :insufficient_funds}
  end

  def execute(
        %Account{account_uuid: account_uuid, closed?: false},
        %TransferBetweenAccounts{
          account_uuid: account_uuid,
          to_uuid: to_uuid,
          amount: amount,
          transfer_uuid: transfer_uuid
        }
      ) do
    %MoneyTransferRequested{
      account_uuid: account_uuid,
      to_uuid: to_uuid,
      amount: amount,
      transfer_uuid: transfer_uuid
    }
  end

  def execute(
        %Account{},
        %TransferBetweenAccounts{}
      ) do
    {:error, :not_found}
  end

  # ---

  def apply(
        %Account{} = account,
        %AccountOpened{
          account_uuid: account_uuid,
          initial_balance: initial_balance
        }
      ) do
    %Account{
      account
      | account_uuid: account_uuid,
        current_balance: initial_balance
    }
  end

  def apply(
        %Account{
          account_uuid: account_uuid,
          current_balance: _current_balance
        } = account,
        %DepositedIntoAccount{
          account_uuid: account_uuid,
          new_current_balance: new_current_balance
        }
      ) do
    %Account{
      account
      | current_balance: new_current_balance
    }
  end

  def apply(
        %Account{
          account_uuid: account_uuid,
          current_balance: _current_balance
        } = account,
        %WithdrawnFromAccount{
          account_uuid: account_uuid,
          new_current_balance: new_current_balance
        }
      ) do
    %Account{
      account
      | current_balance: new_current_balance
    }
  end

  def apply(
        %Account{account_uuid: account_uuid} = account,
        %AccountClosed{
          account_uuid: account_uuid
        }
      ) do
    %Account{
      account
      | closed?: true
    }
  end

  def apply(
        %Account{} = account,
        %MoneyTransferRequested{}
      ) do
    account
  end
end
