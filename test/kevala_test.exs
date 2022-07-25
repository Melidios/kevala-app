defmodule KevalaTest do
  use ExUnit.Case
  doctest Kevala

  @test_csv "test.csv"

  setup do
    data = [
      %{
        "Email" => "jsm@mail.com",
        "First Name" => "John",
        "Last Name" => "Smith",
        "Phone" => "(310)3140033"
      },
      %{
        "Email" => "jsm@mail.com",
        "First Name" => "John",
        "Last Name" => "Smith",
        "Phone" => "(310)99900099"
      },
      %{
        "Email" => "example@john.com",
        "First Name" => "John",
        "Last Name" => "Smith",
        "Phone" => "(310)3140033"
      }
    ]

    [data: data]
  end

  setup context do
    IO.puts("Setting up: #{context.test}")
    :ok
  end

  test "returns ok for generating new csv with different types" do
    assert Kevala.process_file(@test_csv, :phone) == :ok
    assert Kevala.process_file(@test_csv, :email) == :ok
    assert Kevala.process_file(@test_csv, :phone_and_email) == :ok
  end

  test "returns error message when no type provided" do
    {:error, error} = Kevala.process_file(@test_csv)

    assert error ==
             "Duplicate detection strategy required to enter second argument for func. it can be phone, email, or phone_and_email"
  end

  test "returns error message when type privided is wrong" do
    assert Kevala.process_file(@test_csv, :phone_or_email) ==
             "Cannot recognize type of strategy for removing duplicates. Please choose: phone, email, or phone_and_email"
  end

  test "removes duplicates with with same phone", context do
    updated_list = Kevala.remove_dup(context[:data], :phone)
    assert length(updated_list) == 2
  end

  test "removes duplicates with with same email", context do
    updated_list = Kevala.remove_dup(context[:data], :email)
    assert length(updated_list) == 2
  end

  test "removes duplicates with with same email and phone", context do
    updated_list = Kevala.remove_dup(context[:data], :phone_and_email)
    assert length(updated_list) == 1
  end
end
