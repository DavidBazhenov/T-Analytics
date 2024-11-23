package com.example.cybergarden2024android.ui.register

import com.example.cybergarden2024android.data.network.ApiHelper
import com.example.cybergarden2024android.data.network.models.AuthResponse

class RegisterRepository(private val apiService: ApiHelper) {

    suspend fun register(username: String, email: String, password: String): Result<AuthResponse> {
        return try {
            val response = apiService.register(username, email, password)
            if (response.isSuccessful) {
                val user = response.body()
                if (user != null) {
                    Result.success(user)
                } else {
                    Result.failure(Exception("Пустой ответ сервера"))
                }
            } else {
                Result.failure(Exception("Ошибка авторизации: ${response.message()}"))
            }
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
}