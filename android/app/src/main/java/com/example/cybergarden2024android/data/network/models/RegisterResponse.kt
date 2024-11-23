package com.example.cybergarden2024android.data.network.models

import com.google.gson.annotations.SerializedName

class AuthResponse(
    @SerializedName("data") val data: User,
    @SerializedName("success") val success: Boolean,
    @SerializedName("error") val error: String,
)
