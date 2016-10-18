defmodule VoicemailTwimletInterface.PageControllerTest do
  use VoicemailTwimletInterface.ConnCase

  import Mock

  @username Application.get_env(:voicemail_twimlet_interface, :basic_auth)[:username]
  @password Application.get_env(:voicemail_twimlet_interface, :basic_auth)[:password]

  defp using_basic_auth(conn, username, password) do
    header_content = "Basic " <> Base.encode64("#{username}:#{password}")
    conn |> put_req_header("authorization", header_content)
  end

  test "GET / with credentials", %{conn: conn} do
    with_mock ExTwilio.IncomingPhoneNumber, [find: fn(_sid) -> {:ok, %{voice_url: "a fake voice URL"}} end] do
      conn = conn
        |> using_basic_auth(@username, @password)
        |> get("/")

      assert html_response(conn, 200) =~ "a fake voice URL"
    end
  end

  test "GET / without credentials", %{conn: conn} do
    conn = conn
      |> get("/")

    assert response(conn, 401) =~ "401 Unauthorized"
  end
end
