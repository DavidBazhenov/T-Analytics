package com.example.cybergarden2024android.ui.authorize

import android.content.Intent
import android.os.Bundle
import android.text.Editable
import android.text.TextWatcher
import android.util.Log
import android.view.View
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.Observer
import androidx.lifecycle.ViewModelProvider
import com.example.cybergarden2024android.R
import com.example.cybergarden2024android.data.network.ApiHelper
import com.example.cybergarden2024android.data.network.ApiService
import com.example.cybergarden2024android.data.network.Repository
import com.example.cybergarden2024android.databinding.ActivityAuthTidBinding
import com.example.cybergarden2024android.ui.main.MainActivity
import com.example.cybergarden2024android.utils.validators.Validators.isValidPhoneNumber
import com.google.i18n.phonenumbers.PhoneNumberUtil
import com.google.i18n.phonenumbers.Phonenumber

class AuthTiDActivity : AppCompatActivity() {

    private lateinit var binding: ActivityAuthTidBinding
    private lateinit var authViewModel: AuthViewModel

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Привязка макета
        binding = ActivityAuthTidBinding.inflate(layoutInflater)
        setContentView(binding.root)

        // Создание зависимостей вручную
        val apiService = ApiService.create()
        val apiHelper = ApiHelper(apiService)
        val repository = Repository(apiHelper)

        // Инициализация ViewModel через фабрику
        val factory = AuthViewModelFactory(repository)
        authViewModel = ViewModelProvider(this, factory)[AuthViewModel::class.java]

        authViewModel.loginTIDResult.observe(this, Observer { result ->
            Log.i("Dibug1", result.toString())
            result.onSuccess { user ->
                if (user.success) {
                    showError(false, "")
                    val sharedPreferences = getSharedPreferences("MyAppPreferences", MODE_PRIVATE)
                    val editor = sharedPreferences.edit()
                    editor.putString("access_token", user.data.accessToken)
                    editor.putString("name", user.data.name)
                    editor.putString("email", user.data.email)
                    editor.putString("phone", user.data.phone)
                    editor.commit()
                    val intent = Intent(this, MainActivity::class.java)
                    startActivity(intent)
                } else {
                    Log.i("Dibug1", user.success.toString())
                    showError(true, "Неверный логин или пароль")
                }

            }.onFailure { exception ->
                Log.i("Dibug1", "error")
                showError(true, "Ошибка сервера")
            }
        })

        binding.loginButton.setOnClickListener {
            val phone = binding.phoneEditText.text.toString()

            if (isValidPhoneNumber(phone)) {
                authViewModel.loginTID(phone)
            } else {
                showError(true, "Неверный номер")
            }
        }

        binding.backButton.setOnClickListener {
            val intent = Intent(this, AuthActivity::class.java)
            startActivity(intent)
        }

        binding.phoneEditText.addTextChangedListener(object : TextWatcher {
            private var isFormatting = false // Флаг для предотвращения бесконечных циклов

            override fun beforeTextChanged(s: CharSequence?, start: Int, count: Int, after: Int) {}

            override fun onTextChanged(s: CharSequence?, start: Int, before: Int, count: Int) {

            }

            override fun afterTextChanged(s: Editable?) {
                if (isFormatting || s == null) return
                isFormatting = true

                val digitsOnly = s.toString().replace("\\D".toRegex(), "") // Убираем все нецифровые символы
                val formatted = formatPhoneNumber(digitsOnly)
                Log.i("Dibug1", "before -" + formatted)

                // Заменяем текст, только если он изменился
                if (s.toString() != formatted) {
                    s.replace(0, s.length, formatted.toString())
                }

                isFormatting = false
            }

            private fun formatPhoneNumber(number: String) : Any {
                Log.i("Dibug1", "before -" + number)
                when (number.length) {
                    1 -> {
                        return '+' + number.slice(0..0)
                        true
                    }
                    2 -> {
                        return '+' + number.slice(0..0) + ' ' + number.slice(1..1)
                        true
                    }
                    3 -> {
                        return '+' + number.slice(0..0) + ' ' + number.slice(1..2)
                        true
                    }
                    4 -> {
                        return '+' + number.slice(0..0) + ' ' + number.slice(1..3)
                        true
                    }
                    5 -> {
                        return '+' + number.slice(0..0) + ' ' + number.slice(1..3) + ' ' + number.slice(4..4)
                        true
                    }
                    6 -> {
                        return '+' + number.slice(0..0) + ' ' + number.slice(1..3) + ' ' + number.slice(4..5)
                        true
                    }
                    7 -> {
                        return '+' + number.slice(0..0) + ' ' + number.slice(1..3) + ' ' + number.slice(4..6)
                        true
                    }
                    8 -> {
                        return '+' + number.slice(0..0) + ' ' + number.slice(1..3) + ' ' + number.slice(4..6) + '-' + number.slice(7..7)
                        true
                    }
                    9 -> {
                        return '+' + number.slice(0..0) + ' ' + number.slice(1..3) + ' ' + number.slice(4..6) + '-' + number.slice(7..8)
                        true
                    }
                    10 -> {
                        return '+' + number.slice(0..0) + ' ' + number.slice(1..3) + ' ' + number.slice(4..6) + '-' + number.slice(7..8) + '-' + number.slice(9..9)
                        true
                    }
                    11 -> {
                        return '+' + number.slice(0..0) + ' ' + number.slice(1..3) + ' ' + number.slice(4..6) + '-' + number.slice(7..8) + '-' + number.slice(9..10)
                        true
                    }

                }
                return ' '
            }

        })



    }







    private fun showError(isError: Boolean, message: String) {
        if (isError) {
            binding.phoneEditText.setBackgroundResource(R.drawable.rounded_edittext_error)
            binding.errorMessage.text = message
            binding.errorMessage.visibility = View.VISIBLE
        } else {
            binding.phoneEditText.setBackgroundResource(R.drawable.rounded_edittext)
            binding.errorMessage.visibility = View.GONE
        }
    }
}