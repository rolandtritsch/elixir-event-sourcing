defmodule BankAPI.Accounts do
  @moduledoc """
  The Accounts context/domain model.
  """

  import Ecto.Query, warn: false

  alias BankAPI.Repo
  alias BankAPI.Router
  alias BankAPI.Accounts.Projections.Account

  alias BankAPI.Accounts.Commands.{
    OpenAccount,
    CloseAccount,
    DepositIntoAccount,
    WithdrawFromAccount,
    TransferBetweenAccounts
  }

  def uuid_regex do
    ~r/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/
  end

  def open(initial_balance) do
    account_uuid = UUID.uuid4()

    dispatch_result =
      %OpenAccount{
        account_uuid: account_uuid,
        initial_balance: initial_balance
      }
      |> Router.dispatch(consistency: :strong)

    case dispatch_result do
      :ok ->
        {
          :ok,
          %Account{
            uuid: account_uuid,
            current_balance: initial_balance,
            status: "open"
          }
        }

      reply ->
        reply
    end
  end

  def get(id) do
    case Repo.get(Account, id) do
      %Account{} = account ->
        {:ok, account}

      _reply ->
        {:error, :not_found}
    end
  end

  def deposit(id, amount) do
    dispatch_result =
      %DepositIntoAccount{
        account_uuid: id,
        amount: amount
      }
      |> Router.dispatch(consistency: :strong)

    case dispatch_result do
      :ok ->
        {
          :ok,
          Repo.get!(Account, id)
        }

      reply ->
        reply
    end
  end

  def withdraw(id, amount) do
    dispatch_result =
      %WithdrawFromAccount{
        account_uuid: id,
        amount: amount
      }
      |> Router.dispatch(consistency: :strong)

    case dispatch_result do
      :ok ->
        {
          :ok,
          Repo.get!(Account, id)
        }

      reply ->
        reply
    end
  end

  def transfer(account_id, to_id, amount) do
    %TransferBetweenAccounts{
      account_uuid: account_id,
      to_uuid: to_id,
      amount: amount,
      transfer_uuid: UUID.uuid4()
    }
    |> Router.dispatch(consistency: :strong)
  end

  def close(id) do
    %CloseAccount{
      account_uuid: id
    }
    |> Router.dispatch()
  end
end
