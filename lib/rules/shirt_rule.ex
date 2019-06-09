defmodule NovicapChallenge.Rules.ShirtRule do
  @moduledoc """
  Creates a rule to add a 1 euro discount when there's 3 or more tshirts
  """
  @behaviour NovicapChallenge.Rules.RuleBehaviour

  def apply_rule(products) do
    total_tshirts = Enum.count(products, fn p -> p.code == "TSHIRT" end)

    if total_tshirts >= 3 do
      Money.new(-100 * total_tshirts)
    else
      Money.new(0)
    end
  end
end
