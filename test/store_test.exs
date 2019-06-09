defmodule StoreTest do
  use ExUnit.Case, async: true
  alias NovicapChallenge.{Cart, RuleServer, Rules, Store}
  alias Rules.{DoubleVoucherRule, ShirtRule}
  @moduletag filename: "products"

  setup %{filename: filename} do
    Cart.clear()
    RuleServer.clear()
    Store.load_products(filename)
    {:ok, filename: filename}
  end

  describe "Store.add_rule(rule)" do
    test "should not be able to add duplicated rules" do
      assert {:ok, DoubleVoucherRule} == Store.add_rule(DoubleVoucherRule)
      assert {:ok, DoubleVoucherRule} == Store.add_rule(DoubleVoucherRule)
      assert {:ok, ShirtRule} == Store.add_rule(ShirtRule)
      assert {:ok, ShirtRule} == Store.add_rule(ShirtRule)

      rules = RuleServer.all()

      assert Enum.count(rules) == 2
    end
  end

  describe "Store.scan" do
    test "should add products to ProductServer" do
      assert :ok = Store.scan("VOUCHER")
      assert :ok = Store.scan("VOUCHER")
      assert :ok = Store.scan("TSHIRT")

      products = Cart.all()

      assert Enum.count(products) == 3
    end

    test "should raise error if code does not exist" do
      assert_raise RuntimeError, fn -> Store.scan("error") end
    end
  end

  describe "Store.total" do
    test "total is 0.00€ when there are no products" do
      assert Store.total() == "0.00€"
    end

    test "VOUCHER, TSHIRT, and MUG should cost 32.50€" do
      assert {:ok, DoubleVoucherRule} = Store.add_rule(DoubleVoucherRule)
      assert {:ok, ShirtRule} = Store.add_rule(ShirtRule)
      assert :ok = Store.scan("VOUCHER")
      assert :ok = Store.scan("TSHIRT")
      assert :ok = Store.scan("MUG")

      assert Store.total() == "32.50€"
    end

    test "VOUCHER, TSHIRT, and VOUCHER should cost 25.00€" do
      assert {:ok, DoubleVoucherRule} = Store.add_rule(DoubleVoucherRule)
      assert {:ok, ShirtRule} = Store.add_rule(ShirtRule)
      assert :ok = Store.scan("VOUCHER")
      assert :ok = Store.scan("VOUCHER")
      assert :ok = Store.scan("TSHIRT")

      assert Store.total() == "25.00€"
    end

    test "TSHIRT, TSHIRT, TSHIRT, VOUCHER, and TSHIRT should cost 81.00€" do
      assert {:ok, DoubleVoucherRule} = Store.add_rule(DoubleVoucherRule)
      assert {:ok, ShirtRule} = Store.add_rule(ShirtRule)
      assert :ok = Store.scan("TSHIRT")
      assert :ok = Store.scan("TSHIRT")
      assert :ok = Store.scan("TSHIRT")
      assert :ok = Store.scan("VOUCHER")
      assert :ok = Store.scan("TSHIRT")

      assert Store.total() == "81.00€"
    end

    test "VOUCHER, TSHIRT, VOUCHER, VOUCHER, MUG, TSHIRT and TSHIRT should cost 74.50€" do
      assert {:ok, DoubleVoucherRule} = Store.add_rule(DoubleVoucherRule)
      assert {:ok, ShirtRule} = Store.add_rule(ShirtRule)

      assert :ok = Store.scan("VOUCHER")
      assert :ok = Store.scan("TSHIRT")
      assert :ok = Store.scan("VOUCHER")
      assert :ok = Store.scan("VOUCHER")
      assert :ok = Store.scan("MUG")
      assert :ok = Store.scan("TSHIRT")
      assert :ok = Store.scan("TSHIRT")

      assert Store.total() == "74.50€"
    end
  end

  describe "Store.load_products" do
    @tag filename: "products_2"
    test "should enable loading other json file" do
      assert :ok = Store.scan("PEN")
      assert Store.total() == "3.00€"
    end
  end
end
