defmodule Top52.Repo do
  use Ecto.Repo,
    otp_app: :top5_2,
    adapter: Ecto.Adapters.Postgres
end
