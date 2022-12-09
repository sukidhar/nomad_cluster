defmodule NomadClusterWeb.PageController do
  use NomadClusterWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
