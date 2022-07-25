defmodule Kevala do
  @moduledoc """
  This module breaks down csv into list of maps, then removes duplicates based on type of agument that is provided. It can be: :phone, :email, :phone_and_email.
  Then it generates new csv file.
  """
  @headers ["Email;First Name;Last Name;Phone"]

  def process_file(file, type) do
    File.read!(file)
    |> String.split("\r\n")
    |> Enum.map(&String.split(&1, ";"))
    |> create_hash()
    |> remove_dup(type)
    |> return_csv()
  end

  def process_file(_file) do
    {:error,
     "Duplicate detection strategy required to enter second argument for func. it can be phone, email, or phone_and_email"}
  end

  def create_hash(array) do
    headers = List.first(array)

    array
    |> List.delete_at(0)
    |> Enum.map(fn list ->
      Enum.zip(headers, list) |> Enum.into(%{})
    end)
  end

  def remove_dup(arr, :phone) do
    Enum.uniq_by(arr, fn %{"Phone" => y} -> y end)
  end

  def remove_dup(arr, :email) do
    Enum.uniq_by(arr, fn %{"Email" => y} -> y end)
  end

  def remove_dup(arr, :phone_and_email) do
    arr
    |> Enum.uniq_by(fn %{"Email" => y} -> y end)
    |> Enum.uniq_by(fn %{"Phone" => y} -> y end)
  end

  def remove_dup(_arr, _) do
    {:error,
     "Cannot recognize type of strategy for removing duplicates. Please choose: phone, email, or phone_and_email"}
  end

  def return_csv(arr) when is_list(arr) do
    modified_arr =
      Enum.map(arr, fn x ->
        x
        |> Enum.unzip()
        |> Tuple.to_list()
        |> List.delete_at(0)
        |> List.flatten()
        |> Enum.join(";")
      end)

    csv = List.flatten(@headers, modified_arr) |> Enum.join("\r\n")
    File.write("test1.csv", csv)
  end

  def return_csv({:error, error}), do: error
end
