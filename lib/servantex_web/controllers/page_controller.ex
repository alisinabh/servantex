defmodule ServantexWeb.PageController do
  use ServantexWeb, :controller

  alias Servantex.Accounts

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def google_auth(conn, %{
        "client_id" => client_id,
        "redirect_url" => redirect_url,
        "state" => state
      }) do
    render(conn, "login_oauth.html",
      redirect_url: redirect_url,
      state: state,
      client_id: client_id
    )
  end

  def check_auth(conn, %{
        "email" => email,
        "password" => password,
        "redirect_url" => redirect_url,
        "state" => state,
        "client_id" => client_id
      }) do
    if Accounts.login_correct?(email, password) do
      {:ok, token} = Accounts.make_service_token(email, "control", client_id)

      redirect_url =
        redirect_url <> "#acceess_token=#{token.token}&token_type=bearer&state=#{state}"

      conn
      |> redirect(external: redirect_url)
    else
      conn
      |> put_status(400)
      |> put_flash(:error, "Invalid login data!")
      |> render("login_oauth.html",
        redirect_url: redirect_url,
        client_id: client_id,
        state: state,
        email: email
      )
    end
  end
end
