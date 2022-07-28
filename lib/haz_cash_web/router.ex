defmodule HazCashWeb.Router do
  use HazCashWeb, :router

  import HazCashWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {HazCashWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
    plug HazCash.Admins.Pipeline
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :graphql do
    plug HazCashWeb.Context
  end

  # Set the layout for when an admin signs in
  pipeline :admin_session_layout do
    plug :put_root_layout, {HazCashWeb.Admin.LayoutView, :session}
  end

  pipeline :require_current_admin do
    plug HazCashWeb.Plugs.RequireCurrentAdmin
  end

  # Set the main layout for the admin area
  pipeline :admin_layout do
    plug :put_root_layout, {HazCashWeb.Admin.LayoutView, :root}
  end

  # Set the layout for when a user registers or signs in
  pipeline :session_layout do
    plug :put_root_layout, {HazCashWeb.LayoutView, :session}
  end

  scope "/", HazCashWeb do
    pipe_through :browser

    live "/", PageLive, :index
    live "/pricing", PricingLive.Index, :index
    get "/return_from_stripe", StripeReturnController, :new
  end

  scope "/webhooks", HazCashWeb do
    pipe_through :api

    post "/stripe", StripeWebhookController, :create
  end

  # Other scopes may use custom stacks.
  # scope "/api", HazCashWeb do
  #   pipe_through :api
  # end

  scope path: "/feature-flags" do
    pipe_through [:browser, :require_current_admin]
    forward "/", FunWithFlags.UI.Router, namespace: "feature-flags"
  end


  scope "/api" do
    pipe_through :graphql

    forward "/", Absinthe.Plug, schema: HazCashWeb.Schema
  end

  if Application.get_env(:haz_cash, :env) == :dev do
    forward "/graphiql", Absinthe.Plug.GraphiQL, schema: HazCashWeb.Schema
  end
  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Application.get_env(:haz_cash, :env) in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: HazCashWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Application.get_env(:haz_cash, :env) == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", HazCashWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated, :session_layout]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", HazCashWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
    post "/create-customer-portal-session", StripeCustomerPortalSession, :create

    live_session :current_user, on_mount: HazCashWeb.Live.UserAuth do
      live "/accounts", AccountLive.Index, :index
      live "/accounts/:account_id/members", MemberLive.Index, :index
      live "/subscriptions/new", SubscriptionLive.New, :new
      live "/billing", BillingLive.Index, :index
    end
  end

  # This block hold the routes that requires an authenticated user with an active subscription.
  scope "/", HazCashWeb do
    pipe_through [:browser, :require_authenticated_user] #:require_active_subscription]
    # Add non-live view routes here

    live_session :current_user_with_subscription, on_mount: HazCashWeb.Live.UserAuth do
    
    live "/home", HomeLive, :index

    live "/home/expenses/new", HomeLive, :new_expenses
    live "/home/expenses/:ids", HomeLive, :expenses


    live "/transfers", TransferLive.Index, :index
    live "/transfers/new", TransferLive.Index, :new
    live "/transfers/:id/edit", TransferLive.Index, :edit

    live "/transfers/:id", TransferLive.Show, :show
    live "/transfers/:id/show/edit", TransferLive.Show, :edit
        
    live "/expense_accounts", ExpenseAccountLive.Index, :index
    live "/expense_accounts/new", ExpenseAccountLive.Index, :new
    live "/expense_accounts/:id/edit", ExpenseAccountLive.Index, :edit

    live "/expense_accounts/:id", ExpenseAccountLive.Show, :show
    live "/expense_accounts/:id/show/edit", ExpenseAccountLive.Show, :edit
    
    

    live "/expenses", ExpenseLive.Index, :index
    live "/expenses/new", ExpenseLive.Index, :new
    live "/expenses/:id/edit", ExpenseLive.Index, :edit

    live "/expenses/:id", ExpenseLive.Show, :show
    live "/expenses/:id/show/edit", ExpenseLive.Show, :edit
    
    
    

      # Add live view routes here
      live "/accounts", AccountLive.Index, :index
    end
  end

  scope "/", HazCashWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :edit
    post "/users/confirm/:token", UserConfirmationController, :update
  end

  scope "/admin", HazCashWeb.Admin, as: :admin do
    pipe_through [:browser, :admin_session_layout]

    get "/sign_in", SessionController, :new
    post "/sign_in", SessionController, :create
    delete "/sign_out", SessionController, :delete
    get "/sign_out", SessionController, :delete
    get "/reset_password", ResetPasswordController, :new
    post "/reset_password", ResetPasswordController, :create
    get "/reset_password/:token", ResetPasswordController, :show
  end

  scope "/admin", HazCashWeb.Admin, as: :admin do
    pipe_through [:browser, :require_current_admin, :admin_layout]

    live "/", DashboardLive.Index, :index
    live "/settings", SettingLive.Edit, :edit

    post "/impersonate/:id", UserImpersonationController, :create

    live "/accounts", AccountLive.Index, :index
    live "/accounts/new", AccountLive.Index, :new
    live "/accounts/:id/edit", AccountLive.Index, :edit

    live "/accounts/:id", AccountLive.Show, :show
    live "/accounts/:id/show/edit", AccountLive.Show, :edit

    live "/users", UserLive.Index, :index
    live "/users/new", UserLive.Index, :new
    live "/users/:id", UserLive.Show, :show

    ## BILLING
    live "/customers", CustomerLive.Index, :index
    live "/customers/:id", CustomerLive.Show, :show

    live "/products", ProductLive.Index, :index
    live "/products/:id/edit", ProductLive.Index, :edit
    live "/products/:id", ProductLive.Show, :show
    live "/products/:id/show/edit", ProductLive.Show, :edit

    live "/products/:product_id/plans", PlanLive.Index, :index
    live "/products/:product_id/plans/:id", PlanLive.Show, :show

    live "/subscriptions", SubscriptionLive.Index, :index
    live "/subscriptions/:id", SubscriptionLive.Show, :show

    live "/invoices", InvoiceLive.Index, :index
  end
end
