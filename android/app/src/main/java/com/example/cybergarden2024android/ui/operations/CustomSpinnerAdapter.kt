package com.example.cybergarden2024android.ui.operations

import android.content.Context
import android.graphics.Color
import android.view.View
import android.view.ViewGroup
import android.widget.ArrayAdapter
import android.widget.TextView

class CustomSpinnerAdapter(
    context: Context,
    private val items: List<String>,
    private val selectedItemPosition: Int
) : ArrayAdapter<String>(context, android.R.layout.simple_spinner_item, items) {

    init {
        // Настроим стиль для элементов в выпадающем списке
        setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
    }

    // Переопределяем метод для отображения выбранного элемента
    override fun getView(position: Int, convertView: View?, parent: ViewGroup): View {
        val view = super.getView(position, convertView, parent)
        val textView = view.findViewById<TextView>(android.R.id.text1)

        textView.setTextColor(Color.WHITE)  // Цвет для выбранного элемента

        return view
    }

    // Переопределяем метод для отображения элементов в выпадающем списке
    override fun getDropDownView(position: Int, convertView: View?, parent: ViewGroup): View {
        val view = super.getDropDownView(position, convertView, parent)
        val textView = view.findViewById<TextView>(android.R.id.text1)

            textView.setTextColor(Color.WHITE)  // Цвет для выбранного элемента

        return view
    }
}
