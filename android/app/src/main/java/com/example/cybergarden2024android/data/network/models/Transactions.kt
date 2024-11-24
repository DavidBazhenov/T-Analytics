package com.example.cybergarden2024android.data.network.models

import com.google.gson.annotations.SerializedName

data class Transactions(
    @SerializedName("data") val data: TransactionData,
    @SerializedName("error") val error: String,
    @SerializedName("success") val success: Boolean
)
