package com.example.cybergarden2024android.data.network.models

import com.google.gson.annotations.SerializedName

data class TransactionData(
    @SerializedName("transactions") val transactionsArray: List<ItemTransaction>,
)
