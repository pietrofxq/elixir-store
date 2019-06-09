defmodule NovicapChallenge.RuleServer do
  @moduledoc """
  Store apply_rule functions into a MapSet in an Agent.
  """
  use Agent

  alias Store.Product

  def start_link(_) do
    Agent.start_link(fn -> MapSet.new() end, name: __MODULE__)
  end

  @doc "Returns the list of functions in the server"
  @spec all() :: MapSet.t()
  def all do
    Agent.get(__MODULE__, & &1)
  end

  @doc """
  Adds the apply_rule function from a rule to the Rule Server
  """
  @spec add(([Product.t()] -> Money.t())) :: :ok
  def add(rule_fn) do
    Agent.update(__MODULE__, &MapSet.put(&1, rule_fn))
  end

  @doc "Reset server state"
  def clear do
    Agent.update(__MODULE__, fn _ -> MapSet.new() end)
  end
end
