defmodule NovicapChallenge.Application do
  @moduledoc """
  Main application
  """
  use Application

  def start(_type, _args) do
    children = [
      NovicapChallenge.ProductsManager,
      NovicapChallenge.Cart,
      NovicapChallenge.RuleServer
    ]

    opts = [strategy: :one_for_one, name: NovicapChallenge.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
