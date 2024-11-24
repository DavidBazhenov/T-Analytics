package com.example.cybergarden2024android.data.network

import android.icu.util.Currency
import com.example.cybergarden2024android.data.network.models.AuthResponse
import com.example.cybergarden2024android.data.network.models.Transactions
import com.example.cybergarden2024android.data.network.models.Wallets
import retrofit2.Response
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.Body
import retrofit2.http.GET
import retrofit2.http.Header
import retrofit2.http.POST
import retrofit2.http.PUT

interface ApiService {

    @GET("users/me")
    suspend fun getInfoUser(@Header("Authorization") authHeader: String): Response<AuthResponse>

    @PUT("users/me")
    suspend fun updateUserInfo(@Header("Authorization") authHeader: String, @Body request: UpdateProfileRequest): Response<AuthResponse>

    @POST("auth/login")
    suspend fun login(@Body request: AuthorizationRequest): Response<AuthResponse>

    @POST("auth/phone-login")
    suspend fun loginTID(@Body phone: String): Response<AuthResponse>

    @POST("auth/register")
    suspend fun register(@Body request: RegisterRequest): Response<AuthResponse>

    @POST("wallets")
    suspend fun createWallet(@Header("Authorization") authHeader: String, @Body request: Wallet): Response<Wallet>

    @GET("wallets/findManyWallets")
    suspend fun getWallets(@Header("Authorization") authHeader: String): Response<Wallets>

    @GET("transactions/getAllTransactions")
    suspend fun getAllTransactions(@Header("Authorization") authHeader: String): Response<Transactions>

    companion object {
        private const val BASE_URL = "http://194.87.202.4:3000/"

        fun create(): ApiService {
            val retrofit = Retrofit.Builder()
                .baseUrl(BASE_URL)
                .addConverterFactory(GsonConverterFactory.create())
                .build()
            return retrofit.create(ApiService::class.java)
        }
    }
}

data class RegisterRequest(
    val name: String,
    val email: String,
    val password: String
)

data class AuthorizationRequest(
    val email: String,
    val password: String
)

data class UpdateProfileRequest(
    val name: String?,
    val email: String?,
    val phone: String?
)

data class Wallet(
    val name: String,
    val type: String,
    val balance: Int,
    val currency: String
)

