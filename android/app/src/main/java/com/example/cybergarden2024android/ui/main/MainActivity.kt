package com.example.cybergarden2024android.ui.main

import android.annotation.SuppressLint
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.forEach
import androidx.fragment.app.Fragment
import com.example.cybergarden2024android.R
import com.example.cybergarden2024android.ui.chat.Chat
import com.example.cybergarden2024android.ui.wallet.Wallet
import com.example.cybergarden2024android.ui.operations.Operations
import com.example.cybergarden2024android.ui.profile.Profile
import com.google.android.material.bottomnavigation.BottomNavigationView

class MainActivity : AppCompatActivity() {

    private lateinit var bottomNavigationView: BottomNavigationView
    private val operationsFragment = Operations()
    private val walletFragment = Wallet()
    private val profileFragment = Profile()
    private val chatFragment = Chat()

    @SuppressLint("MissingInflatedId")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        bottomNavigationView = findViewById(R.id.bottomNavigation)

        // Загружаем HomeFragment по умолчанию
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


    }

    private fun replaceFragment(fragment: Fragment) {
        supportFragmentManager.beginTransaction()
            .replace(R.id.fragmentContainer, fragment)
            .commit()
    }
}
