package com.example.cybergarden2024android.ui.operations

import android.util.Log
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.cybergarden2024android.data.network.ApiHelper
import com.example.cybergarden2024android.data.network.models.ItemCreateTransaction
import com.example.cybergarden2024android.data.network.models.TransactionData
import com.example.cybergarden2024android.data.network.models.WalletData
import com.github.mikephil.charting.components.Description
import kotlinx.coroutines.launch

class OperationsViewModel (private val apiHelper: ApiHelper) : ViewModel() {

    fun getWallets(accessToken: String, onSuccess: (WalletData) -> Unit, onError: (String) -> Unit) {
        viewModelScope.launch {
            try {
                val response = apiHelper.getWallets(accessToken)
                if (response.isSuccessful) {
                    onSuccess(response.body()!!.data)
                } else {
                    onError("Ошибка обновления профиля: ${response.message()}")
                }
            } catch (e: Exception) {
                onError("Ошибка подключения: ${e.message}")
            }
        }
    }

    fun getAllTransactions(accessToken: String, onSuccess: (TransactionData) -> Unit, onError: (String) -> Unit) {
        viewModelScope.launch {
            try {
                val response = apiHelper.getAllTransactions(accessToken)
                if (response.isSuccessful) {
                    onSuccess(response.body()!!.data)
                } else {
                    Log.i("Dibug1", response.code().toString())
                    onError("Ошибка обновления профиля: ${response.message()}")
                }
            } catch (e: Exception) {
                Log.i("Dibug1", e.message.toString())
                onError("Ошибка подключения: ${e.message}")
            }
        }
    }

    fun createTransaction(categoryName: String, walletId: String, amount: Double, type: String, date: String, description: String, accessToken: String, onSuccess: (ItemCreateTransaction) -> Unit, onError: (String) -> Unit) {
        viewModelScope.launch {
            try {

                val response = apiHelper.createTransaction(categoryName = categoryName, walletId = walletId, amount = amount, type = type, date = date, description = description, accessToken = accessToken)
                if (response.isSuccessful) {
                    onSuccess(response.body()!!.data)
                } else {
                    Log.i("Dibug1", response.errorBody().toString())
                    onError("Ошибка обновления профиля: ${response.message()}")
                }
            } catch (e: Exception) {
                Log.i("Dibug1", e.message.toString())
                onError("Ошибка подключения: ${e.message}")
            }
        }
    }
}