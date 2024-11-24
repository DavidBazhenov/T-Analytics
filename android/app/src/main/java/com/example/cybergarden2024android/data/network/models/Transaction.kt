package com.example.cybergarden2024android.data.network.models

import com.google.gson.annotations.SerializedName

data class Transaction(
    @SerializedName("data") val data: ItemCreateTransaction,
    @SerializedName("error") val error: String,
    @SerializedName("success") val success: Boolean
)