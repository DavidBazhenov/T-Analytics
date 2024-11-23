package com.example.cybergarden2024android.data.network.models

import com.google.gson.annotations.SerializedName

data class ItemWallet(
    @SerializedName("type") val type: String,
    @SerializedName("name") val name: String,
    @SerializedName("balance") val balance: Int,
    @SerializedName("color") val color: String,
)
