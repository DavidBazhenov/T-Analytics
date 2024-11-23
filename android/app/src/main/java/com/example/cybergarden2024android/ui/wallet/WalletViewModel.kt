package com.example.cybergarden2024android.ui.wallet

import android.util.Log
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.cybergarden2024android.data.network.ApiHelper
import com.example.cybergarden2024android.data.network.models.ItemWallet
import com.example.cybergarden2024android.data.network.models.WalletData
import kotlinx.coroutines.launch

class WalletViewModel(private val apiHelper: ApiHelper) : ViewModel() {



    // Метод для обновления данных пользователя
    fun createWallet(accessToken: String, name: String, currency: String, type: String, onSuccess: () -> Unit, onError: (String) -> Unit) {
        viewModelScope.launch {
            try {
                val response = apiHelper.createWallet(accessToken, name, currency, type)
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

    fun getWallets(accessToken: String, onSuccess: (WalletData) -> Unit, onError: (String) -> Unit) {
        viewModelScope.launch {
            try {
                val response = apiHelper.getWallets(accessToken)
                Log.i("Dibug1", response.code().toString())
                if (response.isSuccessful) {
                    onSuccess(response.body()!!.data)
                } else {
                    onError("Ошибка обновления профиля: ${response.message()}")
                }
            } catch (e: Exception) {
                Log.i("Dibug1", e.message.toString())
                onError("Ошибка подключения: ${e.message}")
            }
        }
    }
}