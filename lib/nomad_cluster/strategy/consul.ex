defmodule NomadCluster.Strategy.Consul do
  use GenServer
  use Cluster.Strategy

  alias Cluster.Strategy.State

  @default_consul_url "http://127.0.0.1:8500"

  def start_link(args), do: GenServer.start_link(__MODULE__, args)

  @impl true
  def init([%State{meta: nil} = state]), do: init([%State{state | :meta => MapSet.new()}])

  def init([%State{config: config} = state]) do
    state =
      case Keyword.get(config, :app_name) do
        nil ->
          [app_name, _] =
            node()
            |> to_string()
            |> String.split("@")

          %{state | config: Keyword.put(config, :app_name, app_name)}

        app_name when is_binary(app_name) and app_name != "" ->
          state

        app_name ->
          raise ArgumentError,
                "Consul strategy is selected, but :app_name" <>
                  " is invalid, got: #{inspect(app_name)}"
      end

    {:ok, state, 0}
  end

  def get_nodes(%State{config: config} = state) do
    case :httpc.request(url(config), headers(config)) do
      {:ok, {{_version, 200, _status}, _headers, body}} ->
        body
        |> Jason.decode!()

      _ ->
        nil
    end
  end

  defp url(config) do
    base_url =
      config
      |> Keyword.get(:consul_url, @default_consul_url)
      |> URI.parse()

    %{base_url | path: "/v1/catlog/service/#{config[:service_name]}"}
  end

  def headers(config) do
    case Keyword.get(config, :access_token) do
      nil ->
        []

      access_token ->
        [{"X-Consul-Token", "#{access_token}"}]
    end
  end
end
