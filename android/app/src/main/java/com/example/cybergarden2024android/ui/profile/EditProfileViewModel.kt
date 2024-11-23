package com.example.cybergarden2024android.ui.profile

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.cybergarden2024android.data.network.ApiHelper
import kotlinx.coroutines.launch

class EditProfileViewModel(private val apiHelper: ApiHelper) : ViewModel() {

    // Метод для обновления данных пользователя
    fun updateProfile(accessToken: String, name: String, email: String, phone: String, onSuccess: () -> Unit, onError: (String) -> Unit) {
        viewModelScope.launch {
            try {
                val response = apiHelper.updateUserProfile(accessToken, name, email, phone)
                if (response.isSuccessful) {
                    onSuccess()
                } else {
                    onError("Ошибка обновления профиля: ${response.message()}")
                }
            } catch (e: Exception) {
                onError("Ошибка подключения: ${e.message}")
            }
        }
    }
}