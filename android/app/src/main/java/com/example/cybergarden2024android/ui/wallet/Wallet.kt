package com.example.cybergarden2024android.ui.wallet;

import android.content.Context.MODE_PRIVATE
import android.graphics.Color
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.EditText
import android.widget.TextView
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import com.example.cybergarden2024android.R
import com.example.cybergarden2024android.data.network.ApiHelper
import com.example.cybergarden2024android.data.network.ApiService
import com.example.cybergarden2024android.data.network.models.ItemWallet
import com.example.cybergarden2024android.databinding.FragmentWalletBinding
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.google.android.material.bottomsheet.BottomSheetDialog
import com.github.mikephil.charting.charts.LineChart
import com.github.mikephil.charting.components.XAxis
import com.github.mikephil.charting.components.YAxis
import com.github.mikephil.charting.data.Entry
import com.github.mikephil.charting.data.LineData
import com.github.mikephil.charting.data.LineDataSet

class Wallet : Fragment(R.layout.fragment_wallet) {
    private var _binding: FragmentWalletBinding? = null
    private val binding get() = _binding!!

    private lateinit var viewModel: WalletViewModel
    private var listWallets: MutableList<ItemWallet> = mutableListOf()
    private lateinit var itemWalletAdapter: ItemWalletAdapter



    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Инициализация ViewBinding
        _binding = FragmentWalletBinding.inflate(inflater, container, false)

        val apiHelper = ApiHelper(ApiService.create())
        val factory = WalletViewModelFactory(apiHelper)
        viewModel = ViewModelProvider(this, factory)[WalletViewModel::class.java]

        val sharedPreferences = requireContext().getSharedPreferences("MyAppPreferences", MODE_PRIVATE)
        var token = sharedPreferences.getString("access_token", null)
        val bearerToken = "Bearer $token"

        itemWalletAdapter = ItemWalletAdapter(listWallets)
        binding.listWallets.layoutManager = LinearLayoutManager(requireContext())
        binding.listWallets.adapter = itemWalletAdapter

        viewModel.getWallets(
            bearerToken,
            onSuccess = { data ->
                val list = data.wallets
                Log.i("Dibug1", list.toString())
                listWallets.clear()
                listWallets.addAll(list)
                itemWalletAdapter.notifyDataSetChanged()
            },
            onError = { errorMessage ->
                Log.e("Error", errorMessage)
            }
        )


        binding.newAccountButton.setOnClickListener {
            showBottomSheetDialog(type = "bank", accessToken = token)
        }
        binding.newWalletButton.setOnClickListener {
            showBottomSheetDialog(type = "cash", accessToken = token)
        }

        setupChart(binding.lineChart)





        return binding.root
    }

    override fun onDestroyView() {
        super.onDestroyView()
        // Очищаем ссылку на binding, чтобы избежать утечек памяти
        _binding = null
    }

    private fun setupChart(lineChart: LineChart) {
        // Данные для графика
        val dataSet1 = createLineDataSet(
            data = listOf(Entry(0f, 100f), Entry(1f, 200f), Entry(2f, 150f), Entry(3f, 300f)),
            label = "Серия 1",
            color = Color.GREEN
        )
        val dataSet2 = createLineDataSet(
            data = listOf(Entry(0f, 50f), Entry(1f, 100f), Entry(2f, 120f), Entry(3f, 200f)),
            label = "Серия 2",
            color = Color.BLUE
        )
        val dataSet3 = createLineDataSet(
            data = listOf(Entry(0f, 20f), Entry(1f, 60f), Entry(2f, 80f), Entry(3f, 100f)),
            label = "Серия 3",
            color = Color.CYAN
        )

        // Установка данных в график
        val lineData = LineData(dataSet1, dataSet2, dataSet3)
        lineChart.data = lineData

        // Настройка осей
        val xAxis: XAxis = lineChart.xAxis
        xAxis.position = XAxis.XAxisPosition.BOTTOM
        xAxis.textColor = Color.WHITE
        xAxis.valueFormatter = MonthValueFormatter() // Кастомный формат
        xAxis.setDrawGridLines(false)

        val yAxisLeft: YAxis = lineChart.axisLeft
        yAxisLeft.textColor = Color.WHITE

        val yAxisRight: YAxis = lineChart.axisRight
        yAxisRight.isEnabled = false

        // Другие настройки
        lineChart.legend.isEnabled = false
        lineChart.description.isEnabled = false
        lineChart.legend.textColor = Color.WHITE
        lineChart.setBackgroundColor(Color.DKGRAY)
        lineChart.invalidate() // Обновить график
    }

    private fun createLineDataSet(data: List<Entry>, label: String, color: Int): LineDataSet {
        return LineDataSet(data, label).apply {
            this.color = color
            lineWidth = 2f
            setDrawFilled(true)
            fillColor = color
            fillAlpha = 80
            setDrawCircles(false)
            setDrawValues(false) // Отключение отображения значений
            mode = LineDataSet.Mode.CUBIC_BEZIER // Сглаживание линии
        }
    }

    // Формат отображения месяцев
    inner class MonthValueFormatter : com.github.mikephil.charting.formatter.ValueFormatter() {
        private val months = listOf("Сент.", "Окт.", "Нояб.", "Дек.")
        override fun getFormattedValue(value: Float): String {
            return months.getOrNull(value.toInt()) ?: value.toString()
        }
    }

    fun showBottomSheetDialog(type: String, accessToken: String?) {
        val dialog = BottomSheetDialog(requireContext(), R.style.BottomSheetDialogTheme)
        val view = layoutInflater.inflate(R.layout.bottom_sheet_new_wallet, null)
        dialog.setCancelable(true)
        dialog.setContentView(view)
        dialog.behavior.state = BottomSheetBehavior.STATE_EXPANDED
        dialog.show()
        var checked = "RUB"
        val rub = view.findViewById<TextView>(R.id.rub)
        rub.setBackgroundResource(R.drawable.rounded_bg_yellow)
        val error = view.findViewById<TextView>(R.id.errorMessage)
        val usd = view.findViewById<TextView>(R.id.usd)
        val eur = view.findViewById<TextView>(R.id.eur)
        val gbr = view.findViewById<TextView>(R.id.gbr)
        val nameWallet = view.findViewById<EditText>(R.id.walletEditText)
        val addButton = view.findViewById<Button>(R.id.addButton)

        rub.setOnClickListener {
            when (checked) {
                "USD" -> {
                    usd.setBackgroundResource(R.drawable.bg_inactive_valut)
                }
                "EUR" -> {
                    eur.setBackgroundResource(R.drawable.bg_inactive_valut)
                }
                "GBR" -> {
                    gbr.setBackgroundResource(R.drawable.bg_inactive_valut)
                }
            }
            checked = "RUB"
            rub.setBackgroundResource(R.drawable.rounded_bg_yellow)
        }

        usd.setOnClickListener {
            when (checked) {
                "RUB" -> {
                    rub.setBackgroundResource(R.drawable.bg_inactive_valut)
                }
                "EUR" -> {
                    eur.setBackgroundResource(R.drawable.bg_inactive_valut)
                }
                "GBR" -> {
                    gbr.setBackgroundResource(R.drawable.bg_inactive_valut)
                }
            }
            checked = "USD"
            usd.setBackgroundResource(R.drawable.rounded_bg_yellow)
        }

        eur.setOnClickListener {
            when (checked) {
                "RUB" -> {
                    rub.setBackgroundResource(R.drawable.bg_inactive_valut)
                }
                "USD" -> {
                    usd.setBackgroundResource(R.drawable.bg_inactive_valut)
                }
                "GBR" -> {
                    gbr.setBackgroundResource(R.drawable.bg_inactive_valut)
                }
            }
            checked = "EUR"
            eur.setBackgroundResource(R.drawable.rounded_bg_yellow)
        }

        gbr.setOnClickListener {
            when (checked) {
                "RUB" -> {
                    rub.setBackgroundResource(R.drawable.bg_inactive_valut)
                }
                "USD" -> {
                    usd.setBackgroundResource(R.drawable.bg_inactive_valut)
                }
                "EUR" -> {
                    eur.setBackgroundResource(R.drawable.bg_inactive_valut)
                }
            }
            checked = "GBR"
            gbr.setBackgroundResource(R.drawable.rounded_bg_yellow)
        }

        addButton.setOnClickListener {
            if (nameWallet.text.toString().length === 0) {
                error.text = "Обязательное поле"
                nameWallet.setBackgroundResource(R.drawable.rounded_edittext_error)
            }
            val bearerToken = "Bearer $accessToken"
            if (accessToken != null) {
                viewModel.createWallet(
                    bearerToken,
                    nameWallet.text.toString(),
                    checked,
                    type,
                    onSuccess = {
                        dialog.dismiss()
                    },
                    onError = { errorMessage ->
                        error.text = errorMessage
                        nameWallet.setBackgroundResource(R.drawable.rounded_edittext_error)
                    })
            }
        }

    }
}
