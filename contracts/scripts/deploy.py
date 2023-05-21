from brownie import PulsarBalanceVerifier, PulsarClassifier, Minter, accounts, config, network

# ARBITRUM TEST

def main():
    # Deploy PulsarBalanceVerifier
    print("CURRENT NETWORK: ",network.show_active())
    balance_checker_arbitrum_addr = "0x151E24A486D7258dd7C33Fb67E4bB01919B7B32c"
    dev = accounts.add(config["wallets"]["from_key"])
    PulsarBalanceVerifier.deploy(balance_checker_arbitrum_addr, {'from': dev}, publish_source=True)
    balance_verifier = PulsarBalanceVerifier[-1]

    # Deploy PulsarClassifier
    weth = "0x82af49447d8a07e3bd95bd0d56f35241523fbab1"
    wbtc = "0x2f2a2543b76a4166549f7aab2e75bef0aefc5b0f"
    usdt = "0xfd086bc7cd5c481dcc9c85ebe478a1c0b69fcbb9"
    usdc = "0xff970a61a04b1ca14834a43f5de4533ebddb5cc8"
    conservative_tokens =[weth, wbtc, usdt, usdc]
    eth_usd_price_feed = "0x639Fe6ab55C921f74e7fac1ee960C0B6293ba612"

    PulsarClassifier.deploy(conservative_tokens, eth_usd_price_feed, {'from': dev}, publish_source=True)
    pulsar_classifier = PulsarClassifier[-1]

    #Setup
    POOR_URI = "https://ipfs.io/ipfs/QmPhRbFc14tMRdPefBPRPdNmMQu23UJrvpLYo2ruihtXKB?filename=poor.json"
    LOW_CAP_DEGEN_URI = "https://ipfs.io/ipfs/QmWMB4f6hVVyLnYE17ogKN7TT7BZDQRx93H7m6n6eK74Pm?filename=low_cap_degen.json"
    NFT_DEGEN_URI ="https://ipfs.io/ipfs/Qmcrh6bftb9AH8bzueBgNyuSZKEUjNDaQJkmxS6VXdqkqv?filename=nft_degen.json"
    DEFI_DEGEN_URI = "https://ipfs.io/ipfs/QmbufeksV6ATiZvae1NGzo9EnEkxoqhdYazdUveUp5bU2D?filename=defi_degen.json"
    CONSERVATIVE_URI = "https://ipfs.io/ipfs/QmfTrPkKduncJvxCybkRTsUgFk6Y3fBnQrseGGbLZR9GSZ?filename=conservative.json"
    BOLD_URI = "https://ipfs.io/ipfs/QmY1iMhpLccgzAXzhTkKu9shS7XQZijpL6MKNVJvcqmZ9g?filename=bold.json"
    badge_uris_list = [POOR_URI, LOW_CAP_DEGEN_URI, NFT_DEGEN_URI, DEFI_DEGEN_URI, CONSERVATIVE_URI, BOLD_URI]
    
    tokens = []
    token_balances = []
    token_prices = []
    token_decimals = []
    price_decimals = []
    defi_usd_balances = []
    nft_usd_balances = []

    # Deploy PulsarMinter
    Minter.deploy(balance_verifier.address, pulsar_classifier.address, badge_uris_list, {'from': dev}, publish_source=True)
    minter = Minter[-1]

# Run: brownie run scripts/deploy.py --network arbitrum-main-fork --interactive

# # Success Tx
# tx = minter.createBadge(tokens, token_balances, token_prices, token_decimals, price_decimals, defi_usd_balances, nft_usd_balances, {'from': dev})
# tx.info()


# minter = Contract.from_abi("minter", "0xb259688E7CD7054f9365bE735fc9Bc333F00A406", abi)
# minter.balanceOf("0x00a09004cdB51a646aCF085BE549DF8011E2d265")
# minter.ownerOf(0)
# minter.tokenURI(0)

# DEPLOYED CONTRACT ADDRS ARBITRUM MAINNET:
# Transaction sent: 0xd44630c7ba0bddec3b6edbdefc87a6e0831a752f23906151b08216b461f7f268
#   Gas price: 0.1 gwei   Gas limit: 5040345   Nonce: 4
#   PulsarBalanceVerifier.constructor confirmed   Block: 92856971   Gas used: 4091235 (81.17%)
#   PulsarBalanceVerifier deployed at: 0x5e9c7a0a5E506598A2b30f9000068D6Bf45D7e95

# Transaction sent: 0x14de6537b1d9721283f351d7660e3b7ee9d780ee00e3a7e70180b8d5637216b7
#   Gas price: 0.1 gwei   Gas limit: 9830937   Nonce: 5
#   PulsarClassifier.constructor confirmed   Block: 92857592   Gas used: 8063440 (82.02%)
#   PulsarClassifier deployed at: 0x78e97627652283d7e5DbD50B76f8396faDDB2006

# Transaction sent: 0x24dc94765c73ab6869012ff6f769fd777da75cc89e650605e1dcffcd1d25f080
#   Gas price: 0.1 gwei   Gas limit: 22757837   Nonce: 6
#   Minter.constructor confirmed   Block: 92858099   Gas used: 18745634 (82.37%)
#   Minter deployed at: 0x5d151B8150BCb9F009D32ABEC5A14Ca14011969f


# Deployment + 1st mint cost in usd:
# >>> (0.0068635255 - 0.0036622425) * 1815
# 5.810328645






# weth = "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2"
# ageur="0x1a7e4e63778b4f12a199c062f3efdd288afcbce8"

# weth_balance = 0.01010 * 10 ** 18
# ageur_balance = 8.5946 * 10 ** 18

# tokens = [weth, ageur]
# token_balances = [weth_balance, ageur_balance]

# token_prices = [1850, 1.15]
# token_price_decimals = 0
# defi_contract_usd_balances = [0]
# nft_usd_balances = [0]

# // invalid token balance tx:
# tx = minter_contract.createBadge(tokens, token_balances, token_prices, token_price_decimals, defi_contract_usd_balances, nft_usd_balances, {'from': accounts[0]})


# OLD:
# Transaction sent: 0x94101b46a2b8be8ae525fb8f93a13820cf5b9e0f6c248e93c2c513858fca0472
#   Gas price: 0.1 gwei   Gas limit: 6947634   Nonce: 0
#   PulsarBalanceVerifier.constructor confirmed   Block: 92681313   Gas used: 5601958 (80.63%)
#   PulsarBalanceVerifier deployed at: 0xB246A02fE3ce3C9716683C05ccB437d281c45a2b

# Transaction sent: 0x91baa6af6d0257f16aae3cacdfbb8d61cc9fd2810c025c4b5106e00183eaceb5
#   Gas price: 0.1 gwei   Gas limit: 13458790   Nonce: 1
#   PulsarClassifier.constructor confirmed   Block: 92681333   Gas used: 10972312 (81.53%)
#   PulsarClassifier deployed at: 0x2caC4be21a4b8acBEf038219a52CF3ED272040F0

# Transaction sent: 0xe395a0b5ce60455436470a401dafcc9e49f3f86dd4b32975bdc1f5c579ffa094
#   Gas price: 0.1 gwei   Gas limit: 28513361   Nonce: 2
#   Minter.constructor confirmed   Block: 92681352   Gas used: 23443197 (82.22%)
#   Minter deployed at: 0xb259688E7CD7054f9365bE735fc9Bc333F00A406

# Deployment + 1st mint cost in usd:
# >>> (0.011 - 0.0068635255) * 1815
# 7.507701217499998





