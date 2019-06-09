defmodule NovicapChallenge.Rules.DoubleVoucherRule do
  @moduledoc """
  Creates a rule that gives one voucher for free for every 2
  """
  alias NovicapChallenge.Rules.RuleBehaviour
  @behaviour RuleBehaviour

  @impl true
  def apply_rule(products) do
    difference =
      products
      |> Enum.filter(&RuleBehaviour.filter_by_code(&1, "VOUCHER"))
      |> Enum.chunk_every(2)
      |> Enum.reduce(0, &add_discount/2)

    Money.new(difference)
  end

  defp add_discount([_, _], acc) do
    discount = -500
    acc + discount
  end

  defp add_discount([_], acc) do
    acc
  end
end
