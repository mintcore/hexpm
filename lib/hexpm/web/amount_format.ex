defmodule Hexpm.Web.AmountFormat do
  @moduledoc """
    Formats amounts to more readable formats
  """

  @one_thousand 1_000
  @one_million 1_000_000
  @one_billion 1_000_000_000

  @doc """
    Formats an amount by suffixing a Roman literal.
    Will always show one decimal when it's not zero.

    ## Examples

      iex> Hexpm.Web.AmountFormat.format(2500)
      "2.5K"

      iex> Hexpm.Web.AmountFormat.format(7_001_000)
      "7M"
  """
  def format(amount) when is_number(amount) do
    cond do
      amount < @one_thousand -> to_string(amount)
      amount < @one_million -> format_string(amount / @one_thousand, "K")
      amount < @one_billion -> format_string(amount / @one_million, "M")
      amount -> format_string(amount / @one_billion, "B")
    end
  end

  defp format_string(amount, suffix) when is_float(amount) do
    amount
    |> fuzzy_floor
    |> to_string
    |> Kernel.<>(suffix)
  end

  defp fuzzy_floor(amount) do
    floored_amount = Float.floor(amount, 1)
    if trunc(amount) == floored_amount do
      Kernel.trunc(floored_amount)
    else
      floored_amount
    end
  end
end
