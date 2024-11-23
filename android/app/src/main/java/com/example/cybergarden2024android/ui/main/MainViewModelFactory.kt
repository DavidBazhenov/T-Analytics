package com.example.cybergarden2024android.ui.main;


import android.util.Log
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import com.example.cybergarden2024android.data.network.Repository

class MainViewModelFactory(private val repository: Repository) : ViewModelProvider.Factory {
    override fun <T : ViewModel> create(modelClass: Class<T>): T {
        Log.d("DEBUG", "Rgdgdagfga")
        if (modelClass.isAssignableFrom(MainViewModel::class.java)) {
            Log.d("DEBUG", "RegisterViewModelFactory: Creating RegisterViewModel")
            return MainViewModel(repository) as T
        }
        throw IllegalArgumentException("Unknown ViewModel class")
    }

}
