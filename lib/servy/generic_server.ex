defmodule Servy.GenericServer do

  def start(callback_module, name, initial_state \\ []) do
    # Ensure no process is registered before starting
    if Process.whereis(name) do
      Process.unregister(name)
    end
    pid = spawn(__MODULE__, :listen_loop, [initial_state, callback_module])
    Process.register(pid, name)
    pid
  end

  def stop(name) do
    if pid = Process.whereis(name) do
      Process.exit(pid, :normal)
    end
    :ok
  end

  def call(pid, message) do
    send pid, {:call, self(), message}

    receive do {:response, response} -> response end
  end

  def cast(pid, message) do
    send pid, {:cast, message}
  end

  def listen_loop(state, callback_module) do
    receive do
      {:call, sender, message} when is_pid(sender) ->
        {response, new_state} = callback_module.handle_call(message, state)
        send sender, {:response, response}
        listen_loop(new_state, callback_module)

      {:cast, message} ->
        new_state = callback_module.handle_cast(message, state)
        listen_loop(new_state, callback_module)

      other ->
        new_state = callback_module.handle_info(other, state)
        listen_loop(new_state, callback_module)
    end
  end
end
