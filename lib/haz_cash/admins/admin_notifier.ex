defmodule HazCash.Admins.AdminNotifier do
  @moduledoc """
  This module contains notifications aimed towards the admins.
  """
  use Phoenix.Swoosh, view: HazCashWeb.EmailView, layout: {HazCashWeb.LayoutView, :email}

  import Swoosh.Email
  import HazCash.Mailer, only: [base_email: 0, premail: 1]

  @doc """
  This email is used when an admin needs to login with a magic link
  """
  def admin_login_link(%{email: email, url: url}) do
    base_email()
    |> subject("Login token")
    |> to(email)
    |> render_body("admin_login_link.html", title: "Login token", url: url)
    |> premail()
  end
end
