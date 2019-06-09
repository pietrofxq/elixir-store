defmodule NovicapChallenge.Product do
  @moduledoc """
  Product struct
  """
  @type t() :: %__MODULE__{
          code: String.t(),
          name: String.t(),
          price: String.t()
        }
  defstruct code: "", name: "", price: 0

  def new(code, name, price) do
    %__MODULE__{
      code: code,
      name: name,
      price: Money.new(price)
    }
  end

  def new do
    %__MODULE__{}
  end
end
