defmodule Finch.HTTP1Server do
  @moduledoc false

  def start(port) do
    children = [
      Plug.Adapters.Cowboy.child_spec(
        scheme: :http,
        plug: Finch.HTTP1Server.PlugRouter,
        options: [
          port: port,
          otp_app: :finch,
          protocol_options: [
            idle_timeout: 3_000,
            request_timeout: 10_000
          ]
        ]
      )
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end

defmodule Finch.HTTP1Server.PlugRouter do
  @moduledoc false

  use Plug.Router

  plug(:match)

  plug(:dispatch)

  get "/" do
    name = conn.params["name"] || "world"

    conn
    |> send_resp(200, "Hello #{name}!")
    |> halt()
  end
end
