package com.example.cybergarden2024android.ui.wallet

import android.graphics.Color
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.cardview.widget.CardView
import androidx.recyclerview.widget.RecyclerView
import com.example.cybergarden2024android.R
import com.example.cybergarden2024android.data.network.models.ItemWallet

class ItemWalletAdapter (private val items: List<ItemWallet>) : RecyclerView.Adapter<ItemWalletAdapter.ViewHolder>() {

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val type: ImageView = view.findViewById(R.id.iconWallet)
        val name: TextView = view.findViewById(R.id.nameWallet)
        val balance: TextView = view.findViewById(R.id.balanceWallet)
        val typeBg: CardView = view.findViewById(R.id.iconWalletBg)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.item_wallet, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val item = items[position]
        if (item.type == "bank") {
            holder.type.setImageResource(R.drawable.cards)
        }
        else {
            holder.type.setImageResource(R.drawable.new_wallet)
        }
        holder.typeBg.setCardBackgroundColor(Color.parseColor(item.color))
        holder.name.text = item.name
        holder.balance.text = item.balance.toString() + ".0" + " " + item.currency
    }

    override fun getItemCount() = items.size
}