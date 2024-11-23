package com.example.cybergarden2024android.ui.register

import android.util.Log
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider

class RegisterViewModelFactory(private val RegisterRepository: RegisterRepository) : ViewModelProvider.Factory {
    override fun <T : ViewModel> create(modelClass: Class<T>): T {
        Log.d("DEBUG", "Rgdgdagfga")
        if (modelClass.isAssignableFrom(RegisterViewModel::class.java)) {
            Log.d("DEBUG", "RegisterViewModelFactory: Creating RegisterViewModel")
            return RegisterViewModel(RegisterRepository) as T
        }
        throw IllegalArgumentException("Unknown ViewModel class")
    }

}
