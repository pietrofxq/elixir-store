defmodule NovicapChallenge.ProductsManager do
  @moduledoc """
  Module to handle the current list of available products
  """
  use Agent

  alias NovicapChallenge.Product

  def start_link(_) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def load_products(filename \\ "products") do
    file = File.read!("./products/#{filename}.json")

    products =
      file
      |> Jason.decode!()
      |> parse_json

    Agent.update(__MODULE__, fn _ -> products end)
  end

  def get_products do
    Agent.get(__MODULE__, & &1)
  end

  def get_product_by_code(code) do
    case Map.fetch(get_products(), code) do
      {:ok, value} -> value
      :error -> raise "Code not found"
    end
  end

  defp parse_json(products) do
    Enum.reduce(products, %{}, fn item, acc ->
      code = item["code"]

      Map.put(
        acc,
        code,
        Product.new(code, item["name"], item["price"])
      )
    end)
  end
end
