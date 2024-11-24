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
import com.example.cybergarden2024android.data.network.models.ItemTransaction
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
import java.text.DecimalFormat
import java.text.SimpleDateFormat
import java.time.LocalDate
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter
import java.time.temporal.ChronoUnit
import java.util.Locale

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
                binding.summWallets.text = formatNumber(data.summ)
            },
            onError = { errorMessage ->
                Log.e("Error", errorMessage)
            }
        )

        viewModel.getAllTransactions(
            bearerToken,
            onSuccess = { data ->
                setupChart(binding.lineChart, data.transactionsArray, listWallets)
                Log.i("Dibug1", data.toString())
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







        return binding.root
    }
    

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }

    fun formatNumber(number: Double): String {
        val decimalFormat = DecimalFormat("#,###.0")
        return decimalFormat.format(number) + " ₽"
    }

    private fun setupChart(lineChart: LineChart, transactions: List<ItemTransaction>, wallets: List<ItemWallet>) {
        val linedata = generateChartData(transactions, wallets)

        // Установка данных в график
        val lineData = LineData(linedata)
        lineChart.data = lineData

        val xAxis: XAxis = lineChart.xAxis
        xAxis.axisMinimum = 0f
        xAxis.axisMaximum = extractMonthsFromTransactions(transactions).size - 1.toFloat()
        xAxis.granularity = 1f
        xAxis.labelCount = extractMonthsFromTransactions(transactions).size - 1
        xAxis.position = XAxis.XAxisPosition.BOTTOM
        xAxis.textColor = Color.WHITE
        xAxis.valueFormatter = MonthValueFormatter(extractMonthsFromTransactions(transactions)) // Кастомный формат
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
    inner class MonthValueFormatter(private val months: List<String>) : com.github.mikephil.charting.formatter.ValueFormatter() {
        override fun getFormattedValue(value: Float): String {
            return months.getOrNull(value.toInt()) ?: value.toString()
        }
    }

    fun extractMonthsFromTransactions(transactions: List<ItemTransaction>): List<String> {
        val dateFormatter = DateTimeFormatter.ISO_DATE_TIME
        val outputFormatter = DateTimeFormatter.ofPattern("MMM''yy", Locale("ru"))

        val months = transactions.mapNotNull { transaction ->
            val dateStr = transaction.date as? String
            try {
                val localDate = LocalDate.parse(dateStr, dateFormatter)
                localDate.format(outputFormatter).replaceFirstChar { char -> char.uppercaseChar() }
            } catch (e: Exception) {
                null // Пропускаем транзакции с некорректной датой
            }
        }.distinct() // Убираем дубли после форматирования
            .sorted() // Сортируем строки по лексикографическому (хронологическому) порядку
        

        return months.reversed()
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

    fun generateChartData(transactions: List<ItemTransaction>, wallets: List<ItemWallet>): List<LineDataSet> {
        val dateFormatter = SimpleDateFormat("yyyy-MM-dd")
        val monthFormatter = SimpleDateFormat("yyyy-MM")

        // Группируем транзакции по кошелькам и месяцам
        val groupedTransactions = mutableMapOf<String, MutableMap<String, Float>>() // walletId -> (month -> sum)

        for (transaction in transactions) {
            val date = dateFormatter.parse(transaction.date)
            val month = monthFormatter.format(date) // Преобразуем в год-месяц
            val walletId = transaction.walletId
            val amount = transaction.amount

            // Инициализация для кошелька и месяца
            groupedTransactions.computeIfAbsent(walletId) { mutableMapOf() }
            groupedTransactions[walletId]?.merge(month, amount.toFloat()) { old, new -> old + new }
        }

        // Список всех уникальных месяцев для оси X
        val uniqueMonths = groupedTransactions.values
            .flatMap { it.keys }
            .distinct()
            .sorted()

        // Создаем LineDataSet для каждого кошелька
        val dataSets = mutableListOf<LineDataSet>()

        for ((walletId, monthSums) in groupedTransactions) {
            val walletName = wallets.find { it.id == walletId }?.name ?: continue
            val walletColor = wallets.find { it.id == walletId }?.color ?: continue

            val sortedEntries = uniqueMonths.mapIndexedNotNull { index, month ->
                val value = monthSums[month] ?: 0f // Если для месяца нет данных, берем 0
                Entry(index.toFloat(), value) // Индекс месяца на оси X
            }

            val dataSet = createLineDataSet(
                data = sortedEntries,
                label = walletName,
                color = Color.parseColor(walletColor)
            )

            dataSets.add(dataSet)
        }

        return dataSets
    }

}
