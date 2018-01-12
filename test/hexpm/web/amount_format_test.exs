defmodule Hexpm.Web.AmountFormatTest do
  use ExUnit.Case, async: true

  doctest Hexpm.Web.AmountFormat

  @sut Hexpm.Web.AmountFormat

  test "prints 999 as 999", do: assert "999" = @sut.format(999)
  test "prints 1_000 as 1K", do: assert "1K" = @sut.format(1000)
  test "prints 1_234 as 1.2K", do: assert "1.2K" = @sut.format(1234)
  test "prints 9_999 as 9.9K", do: assert "9.9K" = @sut.format(9999)
  test "prints 1_000_000 as 1M", do: assert "1M" = @sut.format(1_000_000)
  test "prints 7_000_000_000 as 7B", do: assert "7B" = @sut.format(7_000_000_000)
end
