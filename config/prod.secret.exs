use Mix.Config

# In this file, we keep production configuration that
# you'll likely want to automate and keep away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or yourself later on).
config :top5_2, Top52Web.Endpoint,
  secret_key_base: "yn1XTjRkwfThxJockwi9ZxFl7vC87jDxa3/l13YPfWR9F1eRZTTfYYzjzEvi3fwt"

# Configure your database
config :top5_2, Top52.Repo,
  username: "postgres",
  password: "postgres",
  database: "top5_2_prod",
  pool_size: 15
