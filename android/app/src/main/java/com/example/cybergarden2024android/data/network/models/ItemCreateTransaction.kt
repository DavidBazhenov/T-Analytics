package com.example.cybergarden2024android.data.network.models

import com.google.gson.annotations.SerializedName

data class ItemCreateTransaction(
    @SerializedName("category") val category: Category,
    @SerializedName("id") val id: String,
    @SerializedName("userId") val userId: String,
    @SerializedName("walletFromId") val walletId: String,
    @SerializedName("amount") val amount: Int,
    @SerializedName("type") val type: String,
    @SerializedName("date") val date: String,
    @SerializedName("description") val description: String,
)