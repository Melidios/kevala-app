# Kevala - Duplicate remover for csv

## Installation
Elixir 1.13.4 (compiled with Erlang/OTP 24)

In order to run service do:
`mix compile`
`iex -S mix`
`Kevala.process_file("test.csv", :phone)` - second argumet can be `:phone`, `:email`, `:phone_and_email`

In order to run tests, do:
`mix test`
