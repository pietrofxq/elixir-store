defmodule NovicapChallenge.Rules.RuleBehaviour do
  @moduledoc """
    This module defines the interface for new rules.
  """
  @callback apply_rule([NovicapChallenge.Product.t()]) :: Money.t()

  def filter_by_code(item, code) do
    String.downcase(item.code) == String.downcase(code)
  end
end
