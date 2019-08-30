defmodule BankAPI.NoOpMiddleware do
  @behaviour Commanded.Middleware

  alias Commanded.Middleware.Pipeline

  def before_dispatch(%Pipeline{} = pipeline) do
    pipeline
  end

  def after_dispatch(%Pipeline{} = pipeline) do
    pipeline
  end

  def after_failure(%Pipeline{} = pipeline) do
    pipeline
  end
end
