package com.example.cybergarden2024android.ui.authorize

import android.util.Log
import com.example.cybergarden2024android.data.network.ApiHelper
import com.example.cybergarden2024android.data.network.models.AuthResponse
import com.example.cybergarden2024android.data.network.models.User

class AuthRepository(private val apiService: ApiHelper) {

    suspend fun login(email: String, password: String): Result<AuthResponse> {
        return try {
            val response = apiService.login(email, password)
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
