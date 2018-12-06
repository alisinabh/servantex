defmodule ServantexWeb.PageController do
  use ServantexWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
