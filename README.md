# Servy

Servy is the work in progress following PragmaticStudio Elixir course

## Starting the Server

To start the auxiliar processes and the HTTP server on port 4000, run the following in your Elixir shell:

```elixir
mix run --no-halt
```

In order to change the http port, you can modify mix.exs or run:

```elixir
elixir --erl "-servy port 5000" -S mix run --no-halt
```
