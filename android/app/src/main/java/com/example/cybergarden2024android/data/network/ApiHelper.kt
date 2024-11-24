package com.example.cybergarden2024android.data.network

import android.util.Log
import com.example.cybergarden2024android.data.network.models.AuthResponse
import com.example.cybergarden2024android.data.network.models.Transaction
import com.example.cybergarden2024android.data.network.models.Transactions
import com.example.cybergarden2024android.data.network.models.Wallets
import retrofit2.Response

class ApiHelper(private val apiService: ApiService) {

    suspend fun login(email: String, password: String): Response<AuthResponse> {
        val request = AuthorizationRequest(email = email, password = password)
        return apiService.login(request)
    }

    suspend fun loginTID(phone: String): Response<AuthResponse> {
        return apiService.loginTID(phone)
    }

    suspend fun register(username: String, email: String, password: String): Response<AuthResponse> {
        val request = RegisterRequest(name = username, email = email, password = password)
        return apiService.register(request)
    }

    suspend fun getInfoUser(accessToken: String): Response<AuthResponse> {
        return apiService.getInfoUser(accessToken)
    }

    suspend fun updateUserProfile(accessToken: String, name: String?, email: String?, phone: String?): Response<AuthResponse> {
        val request = UpdateProfileRequest(name = name, email = email, phone = phone)
        return apiService.updateUserInfo(accessToken, request)
    }

    suspend fun createWallet(accessToken: String, name: String, currency: String, type: String): Response<Wallet> {
        val request = Wallet(name = name, type = type, currency = currency, balance = 0)
        return apiService.createWallet(accessToken, request)
    }

    suspend fun getWallets(accessToken: String): Response<Wallets> {
        return apiService.getWallets(accessToken)
    }

    suspend fun getAllTransactions(accessToken: String): Response<Transactions> {
        return apiService.getAllTransactions(accessToken)
    }

    suspend fun createTransaction(categoryName: String, walletId: String, amount: Double, type: String, date: String, description: String, accessToken: String): Response<Transaction> {
        val request = CreateCategory(category = Category(name = categoryName), walletFromId = walletId, amount = amount, type = type, date = date, description = description)
        Log.i("Dibug1", request.toString())
        return apiService.createTransaction(accessToken, request)
    }
}
