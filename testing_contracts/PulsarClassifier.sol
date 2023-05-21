// SPDX-License-Identifier: MIT
pragma solidity 0.8.8;

interface ChainlinkPriceFeed {
    function decimals() external view returns (uint8);

    function latestAnswer() external view returns (int256);
}

contract PulsarClassifier {
    // native balance
    // address internal wEthAddress;
    // address internal wBtcAddress;
    // address internal USDTAddress;
    // address internal USDCAddress;
    // address internal BUSDAddress;
    ChainlinkPriceFeed internal nativeTokenPriceOracle;
    uint256 private povertyThresholdUsd = 1000;
    uint256 private decimalPlaceFactor = 10 ** 2; // Precision: 0.01%
    mapping(address => bool) private isConservative;
    mapping(uint8 => uint8) private badgerTypeIndexesPercentages;

    constructor(
        address[] memory conservativeTokenAddresses,
        address _nativeTokenPriceOracle
    ) {
        nativeTokenPriceOracle = ChainlinkPriceFeed(_nativeTokenPriceOracle);
        for (uint256 i = 0; i < conservativeTokenAddresses.length; i++) {
            isConservative[conservativeTokenAddresses[i]] = true;
        }
        badgerTypeIndexesPercentages[1] = 50;
        badgerTypeIndexesPercentages[2] = 50;
        badgerTypeIndexesPercentages[3] = 50;
        badgerTypeIndexesPercentages[4] = 90;
    }

    function classifyWallet(
        address wallet,
        address[] memory _tokens,
        uint256[] memory _tokenBalances,
        uint256[] memory _tokenPrices,
        uint8[] memory _tokenDecimals,
        uint8[] memory _priceDecimals,
        uint256[] memory _defiContractUSDBalances,
        uint256[] memory _nftUSDBalances
    ) external view returns (uint8, uint256, uint256, uint256) {
        uint256 _totalUsdTokenBalance = _getTotalUsdTokenBalance(
            wallet,
            _tokenBalances,
            _tokenPrices,
            _tokenDecimals,
            _priceDecimals
        );
        uint256 _totalUsdDefiBalance = _sumUsdBalances(
            _defiContractUSDBalances
        );
        uint256 _totalUsdConservativeTokenBalance = _getTotalUsdConservativeTokenBalance(
                wallet,
                _tokens,
                _tokenBalances,
                _tokenPrices,
                _tokenDecimals,
                _priceDecimals
            );
        uint256 _totalUsdNftBalance = _sumUsdBalances(_nftUSDBalances);
        uint256 _totalUsdGlobalBalance = _totalUsdTokenBalance +
            _totalUsdDefiBalance +
            _totalUsdNftBalance;
        return
            this.classifyBalances(
                _totalUsdGlobalBalance,
                _totalUsdTokenBalance,
                _totalUsdConservativeTokenBalance,
                _totalUsdDefiBalance,
                _totalUsdNftBalance
            );
    }

    function _getTotalUsdTokenBalance(
        address wallet,
        uint256[] memory _tokenBalances,
        uint256[] memory _tokenPrices,
        uint8[] memory _tokenDecimals,
        uint8[] memory _priceDecimals
    ) internal view returns (uint256) {
        uint256 totalUsdTokenBalance = 0;
        for (uint256 i = 0; i < _tokenBalances.length; i++) {
            totalUsdTokenBalance =
                totalUsdTokenBalance +
                ((_tokenBalances[i] * _tokenPrices[i]) /
                    (10 ** (_tokenDecimals[i] + _priceDecimals[i])));
        }
        uint256 nativeUsdBalance = this.getNativeUsdBalance(wallet);
        totalUsdTokenBalance = totalUsdTokenBalance + nativeUsdBalance;
        return totalUsdTokenBalance;
    }

    function _sumUsdBalances(
        uint256[] memory _usdTokenBalances
    ) internal pure returns (uint256) {
        uint256 sum = 0;
        for (uint256 i = 0; i < _usdTokenBalances.length; i++) {
            sum = sum + _usdTokenBalances[i];
        }
        return sum;
    }

    function getNativeUsdBalance(
        address wallet
    ) external view returns (uint256) {
        uint256 nativeTokenPrice = uint256(
            nativeTokenPriceOracle.latestAnswer()
        );
        uint8 priceDecimals = nativeTokenPriceOracle.decimals();
        return (wallet.balance * nativeTokenPrice) / 10 ** (18 + priceDecimals);
    }

    // enum BadgeType {
    //     0-POOR,
    //     1-LOW_CAP_DEGEN,
    //     2-NFT_DEGEN,
    //     3-DEFI_DEGEN,
    //     4-CONSERVATIVE
    //     5-BOLD,
    // }

    function classifyBalances(
        uint256 _totalUsdGlobalBalance,
        uint256 _totalUsdTokenBalance,
        uint256 _totalUsdConservativeTokenBalance,
        uint256 _totalUsdDefiBalance,
        uint256 _totalUsdNftBalance
    ) external view returns (uint8, uint256, uint256, uint256) {
        if (_totalUsdGlobalBalance < povertyThresholdUsd) {
            return (0, 0, _totalUsdGlobalBalance, 0);
        }
        uint256 _conservativeTokenShare = (_totalUsdConservativeTokenBalance *
            decimalPlaceFactor) / _totalUsdGlobalBalance;
        if (_conservativeTokenShare >= badgerTypeIndexesPercentages[4]) {
            return (
                4,
                _conservativeTokenShare,
                _totalUsdGlobalBalance,
                _totalUsdConservativeTokenBalance
            );
        }
        uint256 _defiShare = (_totalUsdDefiBalance * decimalPlaceFactor) /
            _totalUsdGlobalBalance;
        if (_defiShare >= badgerTypeIndexesPercentages[3]) {
            return (
                3,
                _defiShare,
                _totalUsdGlobalBalance,
                _totalUsdDefiBalance
            );
        }
        uint256 _nftShare = (_totalUsdNftBalance * decimalPlaceFactor) /
            _totalUsdGlobalBalance;
        if (_nftShare >= badgerTypeIndexesPercentages[2]) {
            return (2, _nftShare, _totalUsdGlobalBalance, _totalUsdNftBalance);
        }
        uint256 _otherTokenShare = (
            ((_totalUsdTokenBalance - _totalUsdConservativeTokenBalance) *
                decimalPlaceFactor)
        ) / _totalUsdGlobalBalance;
        if (_otherTokenShare >= badgerTypeIndexesPercentages[1]) {
            return (
                1,
                _otherTokenShare,
                _totalUsdGlobalBalance,
                _totalUsdTokenBalance
            );
        }
        return (
            5,
            _totalUsdGlobalBalance,
            _totalUsdTokenBalance,
            _totalUsdConservativeTokenBalance
        );
    }

    function _getTotalUsdConservativeTokenBalance(
        address wallet,
        address[] memory _tokens,
        uint256[] memory _tokenBalances,
        uint256[] memory _tokenPrices,
        uint8[] memory _tokenDecimals,
        uint8[] memory _priceDecimals
    ) internal view returns (uint256) {
        uint256 usdConservativeTokensBalance = 0;
        for (uint256 i = 0; i < _tokens.length; i++) {
            if (isConservative[_tokens[i]]) {
                usdConservativeTokensBalance =
                    usdConservativeTokensBalance +
                    ((_tokenBalances[i] * _tokenPrices[i]) /
                        (10 ** (_tokenDecimals[i] + _priceDecimals[i])));
            }
        }
        uint256 NativeUsdBalance = this.getNativeUsdBalance(wallet);
        usdConservativeTokensBalance =
            usdConservativeTokensBalance +
            NativeUsdBalance;
        return usdConservativeTokensBalance;
    }
}

// ------------------------------- Console Testing (ARBITRUM) ------------------------------------------------------//
// weth = "0x82af49447d8a07e3bd95bd0d56f35241523fbab1"
// wbtc = "0x2f2a2543b76a4166549f7aab2e75bef0aefc5b0f"
// usdt = "0xfd086bc7cd5c481dcc9c85ebe478a1c0b69fcbb9"
// usdc = "0xff970a61a04b1ca14834a43f5de4533ebddb5cc8"

// conservative_tokens =[weth, wbtc, usdt, usdc]

// eth_usd_price_feed = "0x639Fe6ab55C921f74e7fac1ee960C0B6293ba612"
// PulsarClassifier.deploy(conservative_tokens, eth_usd_price_feed, {'from': accounts[0]})

// # Conservative wallet test (native only)

// wallet_address = "0xd4c289f4dA68d34b4F4EAAF05755dE11B4DEBb9F"

// tokens = []
// token_balances = []
// token_prices = []
// token_decimals = []
// price_decimals = []
// defi_usd_balances = []
// nft_usd_balances = []

// PulsarClassifier[-1].classifyWallet(wallet_address, tokens, token_balances, token_prices, token_decimals, price_decimals, defi_usd_balances, nft_usd_balances)

// # Conservative wallet test (erc20 only)

// tokens = ["0x2f2a2543b76a4166549f7aab2e75bef0aefc5b0f", "0xfd086bc7cd5c481dcc9c85ebe478a1c0b69fcbb9"]
// token_balances = [100_000_000, 1000_000_000]
// token_prices = [27000*(10**18), 1*(10**18)]
// token_decimals = [8, 6]
// price_decimals = [18, 18]
// defi_usd_balances = [500, 1000, 200]
// nft_usd_balances = [10]

// PulsarClassifier[-1].classifyWallet(wallet_address, tokens, token_balances, token_prices, token_decimals, price_decimals, defi_usd_balances, nft_usd_balances)

// # poor wallet test (erc20 only)

// wallet_address = "0x00a09004cdB51a646aCF085BE549DF8011E2d265"
// moon_pepe_addr = "0xCe0B3F1258189Da17BBd8c7E0509f5f7E001a998"
// moon_pepe_price = 0.00000017
// moon_pepe_decimals = 6

// tokens = [moon_pepe_addr, usdt]
// token_balances = [100_000_000_000_000, 5_000_000]
// token_prices = [moon_pepe_price*(10**18), 1*(10**18)]
// token_decimals = [6, 6]
// price_decimals = [18, 18]
// defi_usd_balances = [3, 2, 6]
// nft_usd_balances = [1]

// PulsarClassifier[-1].classifyWallet(wallet_address, tokens, token_balances, token_prices, token_decimals, price_decimals, defi_usd_balances, nft_usd_balances)

// # low cap degen wallet test (erc20 only)

// wallet_address = "0x00a09004cdB51a646aCF085BE549DF8011E2d265"
// lyra_addr = "0x079504b86d38119f859c4194765029f692b7b7aa"
// lyra_price = 0.08 * 10 ** 18
// lyra_decimals = 18
// lyra_price_decimals = 18

// tokens = [lyra_addr, usdt]
// token_balances = [100_000_000_000_000_000_000_000, 5_000_000]
// token_prices = [lyra_price, 1*10**18]
// token_decimals = [lyra_decimals, 6]
// price_decimals = [18, 18]
// defi_usd_balances = [3, 2, 6]
// nft_usd_balances = [1]

// PulsarClassifier[-1].classifyWallet(wallet_address, tokens, token_balances, token_prices, token_decimals, price_decimals, defi_usd_balances, nft_usd_balances)

// # nft degen wallet test (erc20 only)

// wallet_address = "0x00a09004cdB51a646aCF085BE549DF8011E2d265"
// lyra_addr = "0x079504b86d38119f859c4194765029f692b7b7aa"
// lyra_price = 0.08 * 10 ** 18
// lyra_decimals = 18
// lyra_price_decimals = 18

// tokens = [lyra_addr, usdt]
// token_balances = [1_000_000_000_000_000_000, 5_000_000]
// token_prices = [lyra_price, 1*10**18]
// token_decimals = [lyra_decimals, 6]
// price_decimals = [18, 18]
// defi_usd_balances = [3, 2, 6]
// nft_usd_balances = [1000]

// PulsarClassifier[-1].classifyWallet(wallet_address, tokens, token_balances, token_prices, token_decimals, price_decimals, defi_usd_balances, nft_usd_balances)

// # defi degen wallet test (erc20 only)

// wallet_address = "0x00a09004cdB51a646aCF085BE549DF8011E2d265"
// lyra_addr = "0x079504b86d38119f859c4194765029f692b7b7aa"
// lyra_price = 0.08 * 10 ** 18
// lyra_decimals = 18
// lyra_price_decimals = 18

// tokens = [lyra_addr, usdt]
// token_balances = [1_000_000_000_000_000_000, 5_000_000]
// token_prices = [lyra_price, 1*10**18]
// token_decimals = [lyra_decimals, 6]
// price_decimals = [18, 18]
// defi_usd_balances = [3, 2, 1000]
// nft_usd_balances = [1, 4, 10]

// PulsarClassifier[-1].classifyWallet(wallet_address, tokens, token_balances, token_prices, token_decimals, price_decimals, defi_usd_balances, nft_usd_balances)
