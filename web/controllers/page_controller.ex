defmodule VoicemailTwimletInterface.PageController do
  use VoicemailTwimletInterface.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
