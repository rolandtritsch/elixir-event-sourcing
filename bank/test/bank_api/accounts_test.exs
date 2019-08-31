defmodule BankAPI.Accounts.AccountsTest do
  use BankAPI.Test.InMemoryEventStoreCase

  alias BankAPI.Accounts
  alias BankAPI.Accounts.Projections.Account

  @tag :skip
  test "opens account with valid command" do
    assert {:ok, %Account{current_balance: 1_000}} = Accounts.open(1_000)
  end

  @tag :skip
  test "returns validation errors from dispatch" do
    assert {
             :error,
             :command_validation_failure,
             _cmd,
             ["Expected INTEGER, got STRING \"1_000\", at initial_balance"]
           } = Accounts.open("1_000")

    assert {
             :error,
             :command_validation_failure,
             _cmd,
             ["Argument must be bigger than 0"]
           } = Accounts.open(0)

    assert {
             :error,
             :command_validation_failure,
             _cmd,
             ["Argument must be bigger than 0"]
           } = Accounts.open(-10)
  end
end
