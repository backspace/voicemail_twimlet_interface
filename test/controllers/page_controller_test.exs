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
    with_mock ExTwilio.IncomingPhoneNumber, [find: fn(_sid) -> {:ok, %{voice_url: "http://example.com?Email=hello@example.com&Message=A%20message"}} end] do
      conn = conn
        |> using_basic_auth(@username, @password)
        |> get("/")

      assert html_response(conn, 200) =~ "A message"
      assert html_response(conn, 200) =~ "hello@example.com"
    end
  end

  test "GET / without credentials", %{conn: conn} do
    conn = conn
      |> get("/")

    assert response(conn, 401) =~ "401 Unauthorized"
  end

  test "POST / with credentials", %{conn: conn} do
    number = %{voice_url: "http://example.org"}

    with_mock ExTwilio.IncomingPhoneNumber, [
      find: fn(_sid) -> {:ok, number} end,
      update: fn(number_to_update, voice_url: new_voice_url) ->
        assert number_to_update == number
        assert new_voice_url == "http://example.org?Email=new%40new.com&Message=A+new+message"
      end
    ] do

      conn = conn
        |> using_basic_auth(@username, @password)
        |> post("/", [Email: "new@new.com", Message: "A new message"])

      assert redirected_to(conn, 302) =~ "/"
      assert called ExTwilio.IncomingPhoneNumber.update(number, :_)
    end
  end
end
