package com.example.cybergarden2024android.ui.main

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.cybergarden2024android.data.network.Repository
import com.example.cybergarden2024android.data.network.models.AuthResponse
import kotlinx.coroutines.launch

class MainViewModel(private val repository: Repository) : ViewModel() {

    private val _userInfo = MutableLiveData<Result<AuthResponse>>()
    val userInfo: LiveData<Result<AuthResponse>> get() = _userInfo

    // Функция для авторизации
    fun getUserInfo(accessToken: String) {
        viewModelScope.launch {
            try {
                val result = repository.getInfoUser(accessToken)
                _userInfo.value = result
            } catch (e: Exception) {
                _userInfo.value = Result.failure(e)
            }
        }
    }
}