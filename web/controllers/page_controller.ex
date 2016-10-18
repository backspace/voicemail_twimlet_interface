defmodule VoicemailTwimletInterface.PageController do
  use VoicemailTwimletInterface.Web, :controller

  plug BasicAuth, Application.get_env(:voicemail_twimlet_interface, :basic_auth)

  def index(conn, _params) do
    number_sid = Application.get_env(:voicemail_twimlet_interface, :number_sid)
    {_response, number} = ExTwilio.IncomingPhoneNumber.find(number_sid)
    render conn, "index.html", voice_url: number.voice_url
  end
end
