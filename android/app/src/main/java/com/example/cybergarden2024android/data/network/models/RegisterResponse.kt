package com.example.cybergarden2024android.data.network.models

import com.google.gson.annotations.SerializedName

class AuthResponse(
    @SerializedName("accessToken") val accessToken: String,
    @SerializedName("success") val success: Boolean,
    @SerializedName("error") val error: String,
)
