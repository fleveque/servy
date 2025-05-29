# Servy

Servy is the work in progress following PragmaticStudio Elixir course

## Starting the Server

To start the auxiliar processes and the HTTP server on port 4000, run the following in your Elixir shell:

```elixir
Servy.FourOhFourCounter.start()
Servy.PledgeServer.start()
Servy.SensorServer.start()
spawn(Servy.HttpServer, :start, [4000])
```
