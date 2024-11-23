package com.example.cybergarden2024android.ui.authorize

import android.util.Log
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.cybergarden2024android.data.network.Repository
import com.example.cybergarden2024android.data.network.models.AuthResponse
import com.example.cybergarden2024android.data.network.models.User
import kotlinx.coroutines.launch

class AuthViewModel(private val repository: Repository) : ViewModel() {

    private val _loginResult = MutableLiveData<Result<AuthResponse>>()
    val loginResult: LiveData<Result<AuthResponse>> get() = _loginResult

    private val _loginTIDResult = MutableLiveData<Result<AuthResponse>>()
    val loginTIDResult: LiveData<Result<AuthResponse>> get() = _loginTIDResult

    // Функция для авторизации
    fun login(email: String, password: String) {
        viewModelScope.launch {
            try {
                val result = repository.login(email, password)
                _loginResult.value = result
            } catch (e: Exception) {
                _loginResult.value = Result.failure(e)
            }
        }
    }

    fun loginTID(phone: String) {
        viewModelScope.launch {
            try {
                val result = repository.loginTID(phone)
                _loginResult.value = result
            } catch (e: Exception) {
                _loginResult.value = Result.failure(e)
            }
        }
    }
}
