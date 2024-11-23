package com.example.cybergarden2024android.data.network

import com.example.cybergarden2024android.data.network.models.AuthResponse
import retrofit2.Response
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.Body
import retrofit2.http.GET
import retrofit2.http.POST

interface ApiService {

    @POST("auth/login")
    suspend fun login(@Body request: AuthorizationRequest): Response<AuthResponse>

    @POST("auth/register")
    suspend fun register(@Body request: RegisterRequest): Response<AuthResponse>

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
