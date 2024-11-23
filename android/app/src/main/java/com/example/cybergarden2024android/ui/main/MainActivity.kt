package com.example.cybergarden2024android.ui.main

import android.content.Intent
import android.os.Bundle
import android.util.Log
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.Fragment
import androidx.lifecycle.Observer
import androidx.lifecycle.ViewModelProvider
import com.example.cybergarden2024android.R
import com.example.cybergarden2024android.data.network.ApiHelper
import com.example.cybergarden2024android.data.network.ApiService
import com.example.cybergarden2024android.data.network.Repository
import com.example.cybergarden2024android.ui.authorize.AuthActivity
import com.example.cybergarden2024android.ui.chat.Chat
import com.example.cybergarden2024android.ui.wallet.Wallet
import com.example.cybergarden2024android.ui.operations.Operations
import com.example.cybergarden2024android.ui.profile.Profile
import com.example.cybergarden2024android.ui.register.RegisterViewModel
import com.google.android.material.bottomnavigation.BottomNavigationView

class MainActivity : AppCompatActivity() {

    private lateinit var bottomNavigationView: BottomNavigationView
    private lateinit var mainViewModel: MainViewModel
    private val operationsFragment = Operations()
    private val walletFragment = Wallet()
    private val profileFragment = Profile()
    private val chatFragment = Chat()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        val sharedPreferences = getSharedPreferences("MyAppPreferences", MODE_PRIVATE)
        var token = sharedPreferences.getString("access_token", null)

        if (!isTokenAvailable(token)) {
            redirectToLogin()
        } else {
            val apiService = ApiService.create()
            val apiHelper = ApiHelper(apiService)
            val repository = Repository(apiHelper)
            val factory = MainViewModelFactory(repository)
            mainViewModel = ViewModelProvider(this, factory)[MainViewModel::class.java]
            setupUI(savedInstanceState)
            if (token != null) {
                val bearerToken = "Bearer $token"
                mainViewModel.getUserInfo(bearerToken)

            }

        }
    }

    private fun isTokenAvailable(token: String?): Boolean {
        return !token.isNullOrEmpty()
    }

    private fun redirectToLogin() {
        val intent = Intent(this, AuthActivity::class.java)
        startActivity(intent)
        finish()
    }

    private fun setupUI(savedInstanceState: Bundle?) {
        bottomNavigationView = findViewById(R.id.bottomNavigation)

        // Загружаем OperationsFragment по умолчанию
        if (savedInstanceState == null) {
            supportFragmentManager.beginTransaction()
                .replace(R.id.fragmentContainer, operationsFragment)
                .commit()
        }

        // Устанавливаем слушатель на кнопки bottom navigation
        bottomNavigationView.setOnNavigationItemSelectedListener { item ->
            when (item.itemId) {
                R.id.nav_operations -> {
                    replaceFragment(operationsFragment)
                    true
                }
                R.id.nav_wallet -> {
                    replaceFragment(walletFragment)
                    true
                }
                R.id.nav_chat -> {
                    replaceFragment(chatFragment)
                    true
                }
                R.id.nav_profile -> {
                    replaceFragment(profileFragment)
                    true
                }
                else -> false
            }
        }

        mainViewModel.userInfo.observe(this, Observer { result ->
            result.onSuccess { response ->
                if (response.success) {
                    val sharedPreferences = getSharedPreferences("MyAppPreferences", MODE_PRIVATE)
                    val editor = sharedPreferences.edit()
                    editor.putString("name", response.data.name)
                    editor.putString("email", response.data.email)
                    editor.putString("phone", response.data.phone)
                    editor.apply()
                }
                else {

                }
            }.onFailure { exception ->
                Log.i("Dibug1", exception.message.toString())
            }
        })
    }

    private fun replaceFragment(fragment: Fragment) {
        supportFragmentManager.beginTransaction()
            .replace(R.id.fragmentContainer, fragment)
            .commit()
    }
}
