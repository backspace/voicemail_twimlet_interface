defmodule VoicemailTwimletInterface.PageController do
  use VoicemailTwimletInterface.Web, :controller

  plug BasicAuth, Application.get_env(:voicemail_twimlet_interface, :basic_auth)

  def index(conn, _params) do
    number_sid = Application.get_env(:voicemail_twimlet_interface, :number_sid)
    {_response, number} = ExTwilio.IncomingPhoneNumber.find(number_sid)

    parsed_url = URI.parse(number.voice_url)
    query = URI.decode_query(parsed_url.query)

    render conn, "index.html", voice_url: number.voice_url, query: query
  end

  def update(conn, params) do
    number_sid = Application.get_env(:voicemail_twimlet_interface, :number_sid)
    {_response, number} = ExTwilio.IncomingPhoneNumber.find(number_sid)

    parsed_url = URI.parse(number.voice_url)
    encoded_params = URI.encode_query(params)
    new_url = URI.to_string(URI.merge(parsed_url, "?" <> encoded_params))

    ExTwilio.IncomingPhoneNumber.update(number, voice_url: new_url)

    conn
      |> put_flash(:info, "Updated the voicemail settings successfully.")
      |> redirect(to: "/")
  end
end
