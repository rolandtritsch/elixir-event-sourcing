defmodule BankAPI.Aggregates.AgentTest do
  use BankAPI.Test.InMemoryEventStoreCase

  alias BankAPI.Accounts.Aggregates.Account, as: Aggregate
  alias BankAPI.Accounts.Events.AccountOpened
  alias BankAPI.Accounts.Commands.OpenAccount

  test "ensure agregate gets correct state on creation" do
    uuid = UUID.uuid4()

    account =
      %Aggregate{}
      |> evolve(%AccountOpened{
        account_uuid: uuid,
        initial_balance: 3_000
      })

    assert account.account_uuid == uuid
    assert account.current_balance == 3_000
  end

  test "errors out on invalid opening balance" do
    invalid_command = %OpenAccount{
      account_uuid: UUID.uuid4(),
      initial_balance: -4_000
    }

    assert {:error, :initial_balance_must_be_above_zero} = Aggregate.execute(%Aggregate{}, invalid_command)
  end

  test "errors out on already opened account" do
    command = %OpenAccount{
      account_uuid: UUID.uuid4(),
      initial_balance: 5_000
    }

    assert {:error, :account_already_opened} = Aggregate.execute(%Aggregate{account_uuid: UUID.uuid4()}, command)
  end
end
