defmodule VoicemailTwimletInterface.PageControllerTest do
  use VoicemailTwimletInterface.ConnCase

  import Mock

  test "GET /", %{conn: conn} do
    with_mock ExTwilio.IncomingPhoneNumber, [find: fn(_sid) -> {:ok, %{voice_url: "a fake voice URL"}} end] do
      conn = get conn, "/"
      assert html_response(conn, 200) =~ "a fake voice URL"
    end
  end
end
