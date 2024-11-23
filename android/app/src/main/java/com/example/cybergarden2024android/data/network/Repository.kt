package com.example.cybergarden2024android.data.network

import android.util.Log
import com.example.cybergarden2024android.data.network.models.AuthResponse

class Repository(private val apiService: ApiHelper) {

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

    suspend fun loginTID(phone: String): Result<AuthResponse> {
        return try {
            val response = apiService.loginTID(phone)
            Log.i("Dibug1", response.body().toString())
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

    suspend fun getInfoUser(accessToken: String): Result<AuthResponse> {
        return try {
            val response = apiService.getInfoUser(accessToken)
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

    suspend fun updateInfoUser(accessToken: String, name: String?, email: String?, phone: String?): Result<AuthResponse> {
        return try {
            val response = apiService.updateUserProfile(accessToken, name, email, phone)
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