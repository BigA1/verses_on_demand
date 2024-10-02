defmodule VersesOnDemand.Repo do
  use Ecto.Repo,
    otp_app: :verses_on_demand,
    adapter: Ecto.Adapters.Postgres
end
