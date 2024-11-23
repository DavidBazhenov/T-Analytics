package com.example.cybergarden2024android.ui.profile

import android.content.Context.MODE_PRIVATE
import android.content.Intent
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import com.example.cybergarden2024android.R
import com.example.cybergarden2024android.databinding.FragmentProfileBinding
import com.example.cybergarden2024android.ui.authorize.AuthActivity
import com.example.cybergarden2024android.ui.register.RegisterActivity

class Profile : Fragment(R.layout.fragment_profile) {

    private var _binding: FragmentProfileBinding? = null
    private val binding get() = _binding!!

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Инициализация ViewBinding
        _binding = FragmentProfileBinding.inflate(inflater, container, false)

        val sharedPreferences = requireContext().getSharedPreferences("MyAppPreferences", MODE_PRIVATE)
        val name = sharedPreferences.getString("name", null)
        val email = sharedPreferences.getString("email", null)
        val phone = sharedPreferences.getString("phone", null)

        binding.usernameProfile.text = name
        binding.emailProfile.text = email
        binding.numberProfile.text = phone

        if (email == null || phone == null || email.length == 0 || phone.length == 0) {
            binding.divider.visibility = View.GONE
        }

        // Теперь можно работать с binding
        binding.editProfileButton.setOnClickListener {
            val fragment = EditProfile()
            requireActivity().supportFragmentManager.beginTransaction()
                .replace(R.id.fragmentContainer, fragment)
                .addToBackStack(null)
                .commit()
        }

        binding.exitButton.setOnClickListener {
            val sharedPreferences = requireContext().getSharedPreferences("MyAppPreferences", MODE_PRIVATE)
            val editor = sharedPreferences.edit()
            editor.remove("access_token") // Удаляет ключ access_token
            editor.apply()
            val intent = Intent(requireContext(), AuthActivity::class.java)
            startActivity(intent)
            requireActivity().finish() // Закрыть текущую активность, если нужно
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
