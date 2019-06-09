# NovicapChallenge Store

## Install

Assuming you have Elixir already installed, run `mix deps.get && mix compile` in the project folder.

## Usage

0. Run `iex -S mix` and alias the store module so it's easier to use the functions:

```
alias NovicapChallenge.Store
```

1. Load products with json file. They should be stored in `./products`. Calling without arguments loads the default `products.json` file.

```
Store.load_products()
```

2. Scan products.

```
Store.scan("VOUCHER")
```

3. Add rules. Current rules are: `NovicapChallenge.Rules.DoubleVoucherRule` and `NovicapChallenge.Rules.ShirtRule`.

```
Store.add_rule(NovicapChallenge.Rules.DoubleVoucherRule)
Store.add_rule(NovicapChallenge.Rules.ShirtRule)
```

3. Check the total.

```
Store.total
```

# Tests

run `mix test`
