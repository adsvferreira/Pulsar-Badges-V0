# ------------------------------- Console Testing (ARBITRUM) ------------------------------------------------------#
# weth = "0x82af49447d8a07e3bd95bd0d56f35241523fbab1"
# wbtc = "0x2f2a2543b76a4166549f7aab2e75bef0aefc5b0f"
# usdt = "0xfd086bc7cd5c481dcc9c85ebe478a1c0b69fcbb9"
# usdc = "0xff970a61a04b1ca14834a43f5de4533ebddb5cc8"

# conservative_tokens =[weth, wbtc, usdt, usdc]

# eth_usd_price_feed = "0x639Fe6ab55C921f74e7fac1ee960C0B6293ba612"
# PulsarClassifier.deploy(conservative_tokens, eth_usd_price_feed, {'from': accounts[0]})

# # Conservative wallet test (native only)

# wallet_address = "0xd4c289f4dA68d34b4F4EAAF05755dE11B4DEBb9F"

# tokens = []
# token_balances = []
# token_prices = []
# token_decimals = []
# price_decimals = []
# defi_usd_balances = []
# nft_usd_balances = []

# PulsarClassifier[-1].classifyWallet(wallet_address, tokens, token_balances, token_prices, token_decimals, price_decimals, defi_usd_balances, nft_usd_balances)

# # Conservative wallet test (erc20 only)

# tokens = ["0x2f2a2543b76a4166549f7aab2e75bef0aefc5b0f", "0xfd086bc7cd5c481dcc9c85ebe478a1c0b69fcbb9"]
# token_balances = [100_000_000, 1000_000_000]
# token_prices = [27000*(10**18), 1*(10**18)]
# token_decimals = [8, 6]
# price_decimals = [18, 18]
# defi_usd_balances = [500, 1000, 200]
# nft_usd_balances = [10]

# PulsarClassifier[-1].classifyWallet(wallet_address, tokens, token_balances, token_prices, token_decimals, price_decimals, defi_usd_balances, nft_usd_balances)

# # poor wallet test (erc20 only)

# wallet_address = "0x00a09004cdB51a646aCF085BE549DF8011E2d265"
# moon_pepe_addr = "0xCe0B3F1258189Da17BBd8c7E0509f5f7E001a998"
# moon_pepe_price = 0.00000017
# moon_pepe_decimals = 6

# tokens = [moon_pepe_addr, usdt]
# token_balances = [100_000_000_000_000, 5_000_000]
# token_prices = [moon_pepe_price*(10**18), 1*(10**18)]
# token_decimals = [6, 6]
# price_decimals = [18, 18]
# defi_usd_balances = [3, 2, 6]
# nft_usd_balances = [1]

# PulsarClassifier[-1].classifyWallet(wallet_address, tokens, token_balances, token_prices, token_decimals, price_decimals, defi_usd_balances, nft_usd_balances)

# # low cap degen wallet test (erc20 only)

# wallet_address = "0x00a09004cdB51a646aCF085BE549DF8011E2d265"
# lyra_addr = "0x079504b86d38119f859c4194765029f692b7b7aa"
# lyra_price = 0.08 * 10 ** 18
# lyra_decimals = 18
# lyra_price_decimals = 18

# tokens = [lyra_addr, usdt]
# token_balances = [100_000_000_000_000_000_000_000, 5_000_000]
# token_prices = [lyra_price, 1*10**18]
# token_decimals = [lyra_decimals, 6]
# price_decimals = [18, 18]
# defi_usd_balances = [3, 2, 6]
# nft_usd_balances = [1]

# PulsarClassifier[-1].classifyWallet(wallet_address, tokens, token_balances, token_prices, token_decimals, price_decimals, defi_usd_balances, nft_usd_balances)

# # nft degen wallet test (erc20 only)

# wallet_address = "0x00a09004cdB51a646aCF085BE549DF8011E2d265"
# lyra_addr = "0x079504b86d38119f859c4194765029f692b7b7aa"
# lyra_price = 0.08 * 10 ** 18
# lyra_decimals = 18
# lyra_price_decimals = 18

# tokens = [lyra_addr, usdt]
# token_balances = [1_000_000_000_000_000_000, 5_000_000]
# token_prices = [lyra_price, 1*10**18]
# token_decimals = [lyra_decimals, 6]
# price_decimals = [18, 18]
# defi_usd_balances = [3, 2, 6]
# nft_usd_balances = [1000]

# PulsarClassifier[-1].classifyWallet(wallet_address, tokens, token_balances, token_prices, token_decimals, price_decimals, defi_usd_balances, nft_usd_balances)

# # defi degen wallet test (erc20 only)

# wallet_address = "0x00a09004cdB51a646aCF085BE549DF8011E2d265"
# lyra_addr = "0x079504b86d38119f859c4194765029f692b7b7aa"
# lyra_price = 0.08 * 10 ** 18
# lyra_decimals = 18
# lyra_price_decimals = 18

# tokens = [lyra_addr, usdt]
# token_balances = [1_000_000_000_000_000_000, 5_000_000]
# token_prices = [lyra_price, 1*10**18]
# token_decimals = [lyra_decimals, 6]
# price_decimals = [18, 18]
# defi_usd_balances = [3, 2, 1000]
# nft_usd_balances = [1, 4, 10]

# PulsarClassifier[-1].classifyWallet(wallet_address, tokens, token_balances, token_prices, token_decimals, price_decimals, defi_usd_balances, nft_usd_balances)
