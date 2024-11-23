package com.example.cybergarden2024android.ui.authorize

import android.content.Intent
import android.os.Bundle
import android.text.InputType
import android.text.SpannableString
import android.text.style.UnderlineSpan
import android.util.Log
import android.view.View
import androidx.activity.viewModels
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.Observer
import androidx.lifecycle.ViewModelProvider
import com.example.cybergarden2024android.R
import com.example.cybergarden2024android.data.network.ApiHelper
import com.example.cybergarden2024android.data.network.ApiService
import com.example.cybergarden2024android.databinding.ActivityAuthBinding
import com.example.cybergarden2024android.ui.main.MainActivity
import com.example.cybergarden2024android.ui.register.RegisterActivity
import com.example.cybergarden2024android.utils.validators.Validators.isValidEmail
import com.example.cybergarden2024android.utils.validators.Validators.isValidPassword

class AuthActivity : AppCompatActivity() {

    private lateinit var binding: ActivityAuthBinding
    private lateinit var authViewModel: AuthViewModel

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Привязка макета
        binding = ActivityAuthBinding.inflate(layoutInflater)
        setContentView(binding.root)

        // Создание зависимостей вручную
        val apiService = ApiService.create()
        val apiHelper = ApiHelper(apiService)
        val authRepository = AuthRepository(apiHelper)

        // Инициализация ViewModel через фабрику
        val factory = AuthViewModelFactory(authRepository)
        authViewModel = ViewModelProvider(this, factory)[AuthViewModel::class.java]

        val content = SpannableString("Зарегистрироваться")
        content.setSpan(UnderlineSpan(), 0, content.length, 0)
        binding.regNavButton.text = content

        var isPasswordVisible = false

        binding.viewPasswordButton.setOnClickListener {
            isPasswordVisible = !isPasswordVisible

            if (isPasswordVisible) {
                binding.passwordEditText.inputType =
                    InputType.TYPE_CLASS_TEXT or InputType.TYPE_TEXT_VARIATION_VISIBLE_PASSWORD
            } else {
                binding.passwordEditText.inputType =
                    InputType.TYPE_CLASS_TEXT or InputType.TYPE_TEXT_VARIATION_PASSWORD
            }

            binding.passwordEditText.setSelection(binding.passwordEditText.text.length)
        }

        authViewModel.loginResult.observe(this, Observer { result ->
            result.onSuccess { user ->
                if (user.success) {
                    showError(false, "")
                    val sharedPreferences = getSharedPreferences("app_preferences", MODE_PRIVATE)
                    val editor = sharedPreferences.edit()
                    editor.putString("access_token", user.accessToken)
                    editor.apply()
                    val intent = Intent(this, MainActivity::class.java)
                    startActivity(intent)
                }
                else {
                    showError(true, "Неверный логин или пароль")
                }

            }.onFailure { exception ->
                showError(true, "Ошибка сервера")
            }
        })

        binding.loginButton.setOnClickListener {
            val email = binding.emailEditText.text.toString()
            val password = binding.passwordEditText.text.toString()
            if (isValidEmail(email)) {
                if (isValidPassword(password)) {
                    authViewModel.login(email, password)
                }
                else {
                    showError(true, "Невалидный пароль")
                }
            }
            else {
                showError(true, "Невалидный e-mail")
            }
        }

        binding.regNavButton.setOnClickListener {
            val intent = Intent(this, RegisterActivity::class.java)
            startActivity(intent)
        }

        binding.emailEditText.setOnFocusChangeListener { _, hasFocus ->
            if (hasFocus) {
                showError(false, "")
            }
        }

        binding.passwordEditText.setOnFocusChangeListener { _, hasFocus ->
            if (hasFocus) {
                showError(false, "")
            }
        }
    }

    private fun showError(isError: Boolean, message: String) {
        if (isError) {
            binding.emailEditText.setBackgroundResource(R.drawable.rounded_edittext_error)
            binding.passwordContainer.setBackgroundResource(R.drawable.rounded_edittext_error)
            binding.errorMessage.text = message
            binding.errorMessage.visibility = View.VISIBLE
        } else {
            binding.emailEditText.setBackgroundResource(R.drawable.rounded_edittext)
            binding.passwordContainer.setBackgroundResource(R.drawable.rounded_edittext)
            binding.errorMessage.visibility = View.GONE
        }
    }
}

