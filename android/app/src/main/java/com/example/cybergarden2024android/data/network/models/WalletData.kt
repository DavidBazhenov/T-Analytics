package com.example.cybergarden2024android.data.network.models

import com.google.gson.annotations.SerializedName

data class WalletData(
    @SerializedName("wallets") val wallets: List<ItemWallet>,
    @SerializedName("summ") val summ: Double
)
