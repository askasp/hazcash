defmodule HazCashWeb.PageLiveTest do
  use HazCashWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "SAAS Starter Kit"
    assert render(page_live) =~ "SAAS Starter Kit"
  end
end
