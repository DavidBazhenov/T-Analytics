package com.example.cybergarden2024android.ui.register

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.cybergarden2024android.data.network.Repository
import com.example.cybergarden2024android.data.network.models.AuthResponse
import kotlinx.coroutines.launch

class RegisterViewModel(private val repository: Repository) : ViewModel() {

    private val _registerResult = MutableLiveData<Result<AuthResponse>>()
    val registerResult: LiveData<Result<AuthResponse>> get() = _registerResult

    // Функция для авторизации
    fun register(username: String, email: String, password: String) {
        viewModelScope.launch {
            try {
                val result = repository.register(username, email, password)
                _registerResult.value = result
            } catch (e: Exception) {
                _registerResult.value = Result.failure(e)
            }
        }
    }
}