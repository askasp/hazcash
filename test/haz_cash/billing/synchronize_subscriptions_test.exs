defmodule HazCash.Billing.SynchronizeSubscriptionsTest do
  use HazCash.DataCase, async: true

  alias HazCash.Billing.SynchronizeSubscriptions

  describe "run" do
    test "run/0 syncs subscriptions from stripe and creates them in billing_subscriptions" do
      assert SynchronizeSubscriptions.run() == []
    end
  end
end
