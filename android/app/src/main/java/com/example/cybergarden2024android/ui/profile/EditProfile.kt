package com.example.cybergarden2024android.ui.profile

import android.content.Context.MODE_PRIVATE
import android.content.Intent
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import com.example.cybergarden2024android.R
import com.example.cybergarden2024android.data.network.ApiHelper
import com.example.cybergarden2024android.data.network.ApiService
import com.example.cybergarden2024android.databinding.FragmentEditProfileBinding

class EditProfile : Fragment(R.layout.fragment_edit_profile) {

    private var _binding: FragmentEditProfileBinding? = null
    private val binding get() = _binding!!

    private lateinit var viewModel: EditProfileViewModel

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Инициализация ViewBinding
        _binding = FragmentEditProfileBinding.inflate(inflater, container, false)

        val apiHelper = ApiHelper(ApiService.create())
        val factory = EditProfileViewModelFactory(apiHelper)
        viewModel = ViewModelProvider(this, factory)[EditProfileViewModel::class.java]

        val sharedPreferences = requireContext().getSharedPreferences("MyAppPreferences", MODE_PRIVATE)
        var token = sharedPreferences.getString("access_token", null)
        val name = sharedPreferences.getString("name", null)
        val email = sharedPreferences.getString("email", null)
        val phone = sharedPreferences.getString("phone", null)


        binding.usernameEditText.setText(name)
        binding.emailEditText.setText(email)
        binding.numberEditText.setText(phone)

        binding.saveButton.setOnClickListener {
            val updatedName = binding.usernameEditText.text.toString()
            val updatedEmail = binding.emailEditText.text.toString()
            val updatedPhone = binding.numberEditText.text.toString()

            if (token != null) {
                val bearerToken = "Bearer $token"
                viewModel.updateProfile(
                    bearerToken,
                    updatedName,
                    updatedEmail,
                    updatedPhone,
                    onSuccess = {

                        with(sharedPreferences.edit()) {
                            putString("name", updatedName)
                            putString("email", updatedEmail)
                            putString("phone", updatedPhone)
                            apply()
                        }

                        requireActivity().supportFragmentManager.popBackStack()
                    },
                    onError = { errorMessage ->
                    })
            }
        }

        // Теперь можно работать с binding
        binding.backButton.setOnClickListener {
            val fragment = Profile()
            requireActivity().supportFragmentManager.beginTransaction()
                .replace(R.id.fragmentContainer, fragment)
                .addToBackStack(null)
                .commit()
        }

        // Возвращаем root view
        return binding.root
    }

    override fun onDestroyView() {
        super.onDestroyView()
        // Очищаем ссылку на binding, чтобы избежать утечек памяти
        _binding = null
    }

}
