package com.example.cybergarden2024android.ui.authorize

import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import com.example.cybergarden2024android.data.network.Repository

class AuthViewModelFactory(private val repository: Repository) : ViewModelProvider.Factory {
    @Suppress("UNCHECKED_CAST")
    override fun <T : ViewModel> create(modelClass: Class<T>): T {
        if (modelClass.isAssignableFrom(AuthViewModel::class.java)) {
            return AuthViewModel(repository) as T
        }
        throw IllegalArgumentException("Unknown ViewModel class")
    }
}
