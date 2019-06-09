defmodule NovicapChallenge.Rules.RuleBehaviour do
  @moduledoc """
    This module defines the interface for new rules.
  """
  @callback apply_rule([NovicapChallenge.Product.t()]) :: Money.t()
end
