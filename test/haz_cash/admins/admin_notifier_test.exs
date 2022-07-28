defmodule HazCash.Admins.AdminNotifierTest do
  use HazCash.DataCase, async: true

  alias HazCash.Admins.AdminNotifier

  test "admin login link email" do
    message = %{url: ~s(#somelinkwithtoken), email: "john.doe@example.com"}

    email = AdminNotifier.admin_login_link(message)

    assert email.to == [{"", "john.doe@example.com"}]
    assert email.from == {"", "john.doe@haz_cash.com"}
    assert email.html_body =~ "href=\"#somelinkwithtoken\""
  end
end
