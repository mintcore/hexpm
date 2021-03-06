defmodule Hexpm.Web.DashboardViewTest do
  use Hexpm.ConnCase, async: true

  alias Hexpm.Web.DashboardView

  test "shows verified emails as gravatar options" do
    verified_email = build(:email, email: "verified@mail.com", verified: true)
    unverified_email = build(:email, email: "unverified@mail.com", verified: false)
    user = %{
      emails: [verified_email, unverified_email]
    }

    emails = DashboardView.gravatar_email_options(user)

    assert emails == [
      {"Don't show an avatar", "none"},
      {"verified@mail.com", "verified@mail.com"}
    ]
  end

  test "returns gravatar email as value" do
    gravatar_email = build(:email, gravatar: true)
    other_email = build(:email, gravatar: false)
    user = %{
      emails: [gravatar_email, other_email]
    }

    email = DashboardView.gravatar_email_value(user)

    assert email == gravatar_email.email
  end

  test "returns 'none' if gravatar email is not set" do
    user = %{
      emails: [build(:email, gravatar: false)]
    }

    email = DashboardView.gravatar_email_value(user)

    assert email == "none"
  end
end
