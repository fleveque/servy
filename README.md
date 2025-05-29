# Servy

Servy is the work in progress following PragmaticStudio Elixir course

## Starting the Server

To start the auxiliar processes and the HTTP server on port 4000, run the following in your Elixir shell:

```elixir
{:ok, sup_pid} = Servy.Supervisor.start_link()
```
