package com.example.cybergarden2024android.ui.operations

import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import com.example.cybergarden2024android.data.network.ApiHelper

class OperationsViewModelFactory (private val apiHelper: ApiHelper) : ViewModelProvider.Factory {
    override fun <T : ViewModel> create(modelClass: Class<T>): T {
        if (modelClass.isAssignableFrom(OperationsViewModel::class.java)) {
            return OperationsViewModel(apiHelper) as T
        }
        throw IllegalArgumentException("Unknown ViewModel class")
    }
}