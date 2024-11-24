package com.example.cybergarden2024android.ui.operations

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.example.cybergarden2024android.R
import com.example.cybergarden2024android.data.network.models.DayExpenses

class OperationsDayAdapter(private val days: List<DayExpenses>, private val context: Context) : RecyclerView.Adapter<OperationsDayAdapter.DayViewHolder>() {

    inner class DayViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
        val dateText: TextView = itemView.findViewById(R.id.dateTextOperations)
        val summaryText: TextView = itemView.findViewById(R.id.moneyText)
        val innerRecyclerView: RecyclerView = itemView.findViewById(R.id.innerRecyclerView)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): DayViewHolder {
        val view = LayoutInflater.from(parent.context).inflate(R.layout.item_date_operations, parent, false)
        return DayViewHolder(view)
    }

    override fun onBindViewHolder(holder: DayViewHolder, position: Int) {
        val day = days[position]
        val summaryMoney = day.expenses.sumOf { it.amount.toDouble() }
        holder.dateText.text = day.date
        holder.summaryText.text = "${summaryMoney.toInt()} ₽"

        // Настройка внутреннего RecyclerView
        val innerAdapter = ExpenseAdapter(day.expenses, context)
        holder.innerRecyclerView.layoutManager = LinearLayoutManager(holder.itemView.context)
        holder.innerRecyclerView.adapter = innerAdapter
    }

    override fun getItemCount(): Int = days.size
}