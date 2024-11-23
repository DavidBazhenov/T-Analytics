package com.example.cybergarden2024android.ui.register

import android.content.Intent
import android.os.Bundle
import android.text.Html
import android.text.InputType
import android.text.SpannableString
import android.text.Spanned
import android.text.method.LinkMovementMethod
import android.text.style.ForegroundColorSpan
import android.text.style.URLSpan
import android.text.style.UnderlineSpan
import android.util.Log
import android.view.View
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat
import androidx.lifecycle.Observer
import androidx.lifecycle.ViewModelProvider
import com.example.cybergarden2024android.R
import com.example.cybergarden2024android.data.network.ApiHelper
import com.example.cybergarden2024android.data.network.ApiService
import com.example.cybergarden2024android.data.network.Repository
import com.example.cybergarden2024android.databinding.ActivityRegisterBinding
import com.example.cybergarden2024android.ui.authorize.AuthActivity
import com.example.cybergarden2024android.ui.main.MainActivity
import com.example.cybergarden2024android.utils.validators.Validators.isNotEmpty
import com.example.cybergarden2024android.utils.validators.Validators.isValidEmail
import com.example.cybergarden2024android.utils.validators.Validators.isValidPassword
import com.google.gson.Gson

class RegisterActivity : AppCompatActivity() {

    private lateinit var binding: ActivityRegisterBinding
    private lateinit var registerViewModel: RegisterViewModel

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        binding = ActivityRegisterBinding.inflate(layoutInflater)
        setContentView(binding.root)

        val apiService = ApiService.create()
        val apiHelper = ApiHelper(apiService)
        val repository = Repository(apiHelper)

        val factory = RegisterViewModelFactory(repository)
        registerViewModel = ViewModelProvider(this, factory)[RegisterViewModel::class.java]

        val content = SpannableString("Войти")
        content.setSpan(UnderlineSpan(), 0, content.length, 0)
        binding.loginNavButton.text = content

        var isPasswordVisible = false

        val text = getString(R.string.terms_and_privacy)

        val spannableText = SpannableString(Html.fromHtml(text))
        val linkColor = ContextCompat.getColor(this, R.color.link) // Цвет ссылки из ресурсов

// Применить цвет ко всем ссылкам в тексте
        val links = spannableText.getSpans(0, spannableText.length, URLSpan::class.java)
        for (link in links) {
            val span = ForegroundColorSpan(linkColor)
            spannableText.setSpan(span, spannableText.getSpanStart(link), spannableText.getSpanEnd(link), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE)
        }

        binding.termsTextView.text = spannableText
        binding.termsTextView.movementMethod = LinkMovementMethod.getInstance()

        binding.viewPasswordButton.setOnClickListener {
            isPasswordVisible = !isPasswordVisible

            if (isPasswordVisible) {
                binding.passwordEditTextReg.inputType =
                    InputType.TYPE_CLASS_TEXT or InputType.TYPE_TEXT_VARIATION_VISIBLE_PASSWORD
            } else {
                binding.passwordEditTextReg.inputType =
                    InputType.TYPE_CLASS_TEXT or InputType.TYPE_TEXT_VARIATION_PASSWORD
            }

            binding.passwordEditTextReg.setSelection(binding.passwordEditTextReg.text.length)
        }

        registerViewModel.registerResult.observe(this, Observer { result ->
            result.onSuccess { response ->
                if (response.success) {
                    val sharedPreferences = getSharedPreferences("MyAppPreferences", MODE_PRIVATE)
                    val editor = sharedPreferences.edit()
                    editor.putString("access_token", response.data.accessToken)
                    editor.putString("name", response.data.name)
                    editor.putString("email", response.data.email)
                    editor.putString("phone", response.data.phone)
                    editor.apply()
                    val intent = Intent(this, MainActivity::class.java)
                    startActivity(intent)
                }
                else {
                    if (response.error == "User already exists") {
                        showError(true, "email", "Пользователь с таким email уже существует")
                    }
                }
            }.onFailure { exception ->

            }
        })


        binding.regButton.setOnClickListener {
            val username = binding.usernameEditTextReg.text.toString()
            val email = binding.emailEditTextReg.text.toString()
            val password = binding.passwordEditTextReg.text.toString()
            showError(false, "", "")
            if (isNotEmpty(username) && isNotEmpty(email) && isNotEmpty(password) && isValidEmail(email) && isValidPassword(password)) {
                registerViewModel.register(username, email, password)
            }
            if (!isNotEmpty(username)) {
                showError(true, "username", "Обязательное поле")
            }
            if (!isNotEmpty(email)) {
                showError(true, "email", "Обязательное поле")
            } else if (!isValidEmail(email)) {
                showError(true, "email", "Невалидный email")
            }
            if (!isNotEmpty(password)) {
                showError(true, "password", "Обязательное поле")
            } else if (!isValidPassword(password)) {
                showError(true, "password", "Невалидный пароль")
            }

        }

        binding.loginNavButton.setOnClickListener {
            val intent = Intent(this, AuthActivity::class.java)
            startActivity(intent)
        }
    }

    private fun showError(isError: Boolean, field: String, message: String) {
        if (isError) {
            when (field) {
                "username" -> {
                    binding.usernameEditTextReg.setBackgroundResource(R.drawable.rounded_edittext_error)
                    binding.errorMessageUsername.text = message
                    binding.errorMessageUsername.visibility = View.VISIBLE
                    true
                }
                "email" -> {
                    binding.emailEditTextReg.setBackgroundResource(R.drawable.rounded_edittext_error)
                    binding.errorMessageEmail.text = message
                    binding.errorMessageEmail.visibility = View.VISIBLE
                    true
                }
                "password" -> {
                    binding.passwordContainerReg.setBackgroundResource(R.drawable.rounded_edittext_error)
                    binding.errorMessagePassword.text = message
                    binding.errorMessagePassword.visibility = View.VISIBLE
                    true
                }
                else -> false
            }
        } else {
            binding.usernameEditTextReg.setBackgroundResource(R.drawable.rounded_edittext)
            binding.emailEditTextReg.setBackgroundResource(R.drawable.rounded_edittext)
            binding.passwordContainerReg.setBackgroundResource(R.drawable.rounded_edittext)
            binding.errorMessageUsername.visibility = View.GONE
            binding.errorMessageEmail.visibility = View.GONE
            binding.errorMessagePassword.visibility = View.GONE
        }
    }
}