# Servy

Servy is the work in progress following PragmaticStudio Elixir course

## Starting the Server

To start the HTTP server on port 4000, run the following in your Elixir shell:

```elixir
spawn(Servy.HttpServer, :start, [4000])
```
