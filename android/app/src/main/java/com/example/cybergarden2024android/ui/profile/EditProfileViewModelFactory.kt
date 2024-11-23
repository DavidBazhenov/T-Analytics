package com.example.cybergarden2024android.ui.profile

import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import com.example.cybergarden2024android.data.network.ApiHelper

class EditProfileViewModelFactory(private val apiHelper: ApiHelper) : ViewModelProvider.Factory {
    override fun <T : ViewModel> create(modelClass: Class<T>): T {
        if (modelClass.isAssignableFrom(EditProfileViewModel::class.java)) {
            return EditProfileViewModel(apiHelper) as T
        }
        throw IllegalArgumentException("Unknown ViewModel class")
    }
}