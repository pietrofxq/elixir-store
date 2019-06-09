defmodule NovicapChallenge.Rules.DoubleVoucherRule do
  @moduledoc """
  Creates a rule that gives one voucher for free for every 2
  """
  alias NovicapChallenge.Rules.RuleBehaviour
  @behaviour RuleBehaviour

  def apply_rule(products) do
    discount = -500

    difference =
      products
      |> Enum.filter(fn p -> p.code == "VOUCHER" end)
      |> Enum.chunk_every(2)
      |> Enum.reduce(0, fn group, acc ->
        if length(group) == 2 do
          acc + discount
        else
          acc
        end
      end)

    Money.new(difference)
  end
end
