package com.example.cybergarden2024android.ui.operations

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.core.view.marginBottom
import androidx.recyclerview.widget.RecyclerView
import com.example.cybergarden2024android.R
import com.example.cybergarden2024android.data.network.models.Expense

class ExpenseAdapter(private val expenses: List<Expense>, private val context: Context) : RecyclerView.Adapter<ExpenseAdapter.ExpenseViewHolder>() {

    inner class ExpenseViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
        val icon: TextView = itemView.findViewById(R.id.iconTypeOperation)
        val description: TextView = itemView.findViewById(R.id.description)
        val amount: TextView = itemView.findViewById(R.id.amount)
        val wallet: TextView = itemView.findViewById(R.id.wallet)
        val category: TextView = itemView.findViewById(R.id.category)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ExpenseViewHolder {
        val view = LayoutInflater.from(parent.context).inflate(R.layout.item_operations, parent, false)
        return ExpenseViewHolder(view)
    }

    override fun onBindViewHolder(holder: ExpenseViewHolder, position: Int) {
        val expense = expenses[position]
        holder.description.text = expense.description
        holder.amount.text = "${expense.amount} ₽"
        holder.wallet.text = expense.wallet
        holder.category.text = expense.category
        holder.icon.text = expense.icon
    }

    override fun getItemCount(): Int = expenses.size
}
