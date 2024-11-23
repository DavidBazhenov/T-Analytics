package com.example.cybergarden2024android.ui.wallet

import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import com.example.cybergarden2024android.data.network.ApiHelper

class WalletViewModelFactory (private val apiHelper: ApiHelper) : ViewModelProvider.Factory {
    override fun <T : ViewModel> create(modelClass: Class<T>): T {
        if (modelClass.isAssignableFrom(WalletViewModel::class.java)) {
            return WalletViewModel(apiHelper) as T
        }
        throw IllegalArgumentException("Unknown ViewModel class")
    }
}