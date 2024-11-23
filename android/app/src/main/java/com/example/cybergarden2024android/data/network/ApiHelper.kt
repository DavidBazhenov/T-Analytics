package com.example.cybergarden2024android.data.network

import com.example.cybergarden2024android.data.network.models.AuthResponse
import retrofit2.Response

class ApiHelper(private val apiService: ApiService) {

    suspend fun login(email: String, password: String): Response<AuthResponse> {
        val request = AuthorizationRequest(email = email, password = password)
        return apiService.login(request)
    }

    suspend fun register(username: String, email: String, password: String): Response<AuthResponse> {
        val request = RegisterRequest(name = username, email = email, password = password)
        return apiService.register(request)
    }
}