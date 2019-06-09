defmodule NovicapChallenge.Cart do
  @moduledoc """
  Keeps a list of scanned products
  """

  alias NovicapChallenge.Product

  use Agent

  def start_link(_) do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  @doc """
  Adds a product to the Product Server
  """
  @spec add(Product.t()) :: :ok
  def add(product) do
    Agent.update(__MODULE__, &[product | &1])
  end

  @doc "Returns all products in the Product Server"
  @spec all() :: [Product.t()]
  def all do
    Agent.get(__MODULE__, & &1)
  end

  @doc "Clear list of products"
  def clear do
    Agent.update(__MODULE__, fn _ -> [] end)
  end
end
