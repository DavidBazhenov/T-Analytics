package com.example.cybergarden2024android.utils.validators

object Validators {

    // Валидатор email
    fun isValidEmail(email: String): Boolean {
        val emailRegex = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        return email.matches(emailRegex.toRegex())
    }

    // Валидатор пароля (например, минимум 8 символов, хотя бы одна буква и одна цифра)
    fun isValidPassword(password: String): Boolean {
        val passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        return password.matches(passwordRegex.toRegex())
    }

    fun isValidPhoneNumber(phoneNumber: String): Boolean {
        // Регулярное выражение для проверки формата номера с любым кодом страны
        val phoneRegex = "^\\+\\d \\d{3} \\d{3}-\\d{2}-\\d{2}$".toRegex()
        return phoneRegex.matches(phoneNumber)
    }



    // Общий метод для проверки поля на пустоту
    fun isNotEmpty(field: String): Boolean {
        return field.isNotBlank()
    }
}
