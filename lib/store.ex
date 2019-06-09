defmodule NovicapChallenge.Store do
  @moduledoc """
  Main store API
  """
  alias NovicapChallenge.{Cart, ProductsManager, RuleServer}

  defdelegate load_products(filename), to: ProductsManager
  defdelegate load_products(), to: ProductsManager

  def add_rule(rule) do
    {RuleServer.add(&rule.apply_rule/1), rule}
  end

  def scan(code) when is_binary(code) do
    code
    |> ProductsManager.get_product_by_code()
    |> Cart.add()
  end

  def scan(_), do: raise(ArgumentError, message: "code must be a string")

  @spec total :: binary
  def total do
    products = Cart.all()
    rules = RuleServer.all()

    total =
      Enum.reduce(products, Money.new(0), fn product, acc ->
        Money.add(acc, product.price)
      end)

    rules_difference =
      rules
      |> Enum.map(fn rule ->
        rule.(products)
      end)
      |> Enum.reduce(0, fn difference, acc -> acc + difference.amount end)

    Money.add(total, rules_difference)
    |> Money.to_string(symbol_on_right: true)
  end
end
