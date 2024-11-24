package com.example.cybergarden2024android.ui.operations

import android.content.Context.MODE_PRIVATE
import android.os.Bundle
import android.util.Log

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.AdapterView
import android.widget.ArrayAdapter
import android.widget.Button
import android.widget.EditText
import android.widget.PopupMenu
import android.widget.Spinner
import android.widget.TextView
import androidx.appcompat.widget.SwitchCompat
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import com.example.cybergarden2024android.R
import com.example.cybergarden2024android.data.network.ApiHelper
import com.example.cybergarden2024android.data.network.ApiService
import com.example.cybergarden2024android.data.network.models.DayExpenses
import com.example.cybergarden2024android.data.network.models.Expense
import com.example.cybergarden2024android.data.network.models.ItemWallet
import com.example.cybergarden2024android.databinding.FragmentOperationsBinding
import com.example.cybergarden2024android.ui.wallet.ItemWalletAdapter
import com.example.cybergarden2024android.ui.wallet.WalletViewModelFactory
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.google.android.material.bottomsheet.BottomSheetDialog
import java.time.LocalDate
import java.time.format.DateTimeFormatter

class Operations : Fragment(R.layout.fragment_operations) {
    private var _binding: FragmentOperationsBinding? = null
    private val binding get() = _binding!!
    private var listDaysOperations: MutableList<DayExpenses> = mutableListOf()
    private var listWallets: MutableList<ItemWallet> = mutableListOf()
    private lateinit var viewModel: OperationsViewModel
    private lateinit var operationsAdapter: OperationsDayAdapter

    data class Category(
        val name: String,
        val icon: String
    )

    val categoriesOutcome = listOf(
        Category(name = "Food", icon = "🍔"),
        Category(name = "Transport", icon = "🚗"),
        Category(name = "Shopping", icon = "🛍"),
        Category(name = "Medical", icon = "💊"),
        Category(name = "Entertainment", icon = "🎉"),
        Category(name = "Miscellaneous", icon = "🧾"),
        Category(name = "Housing", icon = "🏠"),
        Category(name = "Gym", icon = "🏋️"),
        Category(name = "Utilities", icon = "🛠"),
        Category(name = "Subscriptions", icon = "📦")
    )

    val categoriesIncome = listOf(
        Category(name = "Advance", icon = "💸"),
        Category(name = "Salary", icon = "💰"),
    )




    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Инициализация ViewBinding
        _binding = FragmentOperationsBinding.inflate(inflater, container, false)

        val apiHelper = ApiHelper(ApiService.create())
        val factory = OperationsViewModelFactory(apiHelper)
        viewModel = ViewModelProvider(this, factory)[OperationsViewModel::class.java]

        val sharedPreferences = requireContext().getSharedPreferences("MyAppPreferences", MODE_PRIVATE)
        var token = sharedPreferences.getString("access_token", null)
        val bearerToken = "Bearer $token"

        operationsAdapter = OperationsDayAdapter(listDaysOperations, requireContext())
        binding.rcOperations.layoutManager = LinearLayoutManager(requireContext())
        binding.rcOperations.adapter = operationsAdapter

        binding.addOperation.setOnClickListener {
            showBottomSheetDialog(listWallets, bearerToken)
        }

        viewModel.getWallets(
            bearerToken,
            onSuccess = { data ->
                val list = data.wallets
                Log.i("Dibug1", list.toString())
                listWallets.clear()
                listWallets.addAll(list)
                operationsAdapter.notifyDataSetChanged()
            },
            onError = { errorMessage ->
                Log.e("Error", errorMessage)
            }
        )

//        viewModel.getAllTransactions(
//            bearerToken,
//            onSuccess = { data ->
//                val sortedTransactions = data.transactionsArray
//                    .sortedByDescending { it.date }  // Сортируем по убыванию даты
//                    .groupBy {
//                        val dateTime = DateTimeFormatter.ISO_DATE_TIME.parse(it.date)  // Парсим строку с датой и временем
//                        val date = LocalDate.from(dateTime)  // Извлекаем только дату
//                        date  // Группируем по дате
//                    }
//
//                val dayExpensesList = sortedTransactions.map { (date, transactions) ->
//                    val wallet = listWallets.find { it.id == transactions.get(0).walletId }
//                    DayExpenses(
//                        date = formatDateString(date.toString()),
//                        expenses = transactions.map { transaction ->
//                            Expense(
//                                category = transaction.category.name,
//                                description = transaction.description,
//                                amount = transaction.amount.toFloat(),
//                                icon = transaction.category.icon,
//                                wallet = wallet!!.name
//                            )
//                        }
//                    )
//                }
//
//                listDaysOperations.clear()
//                listDaysOperations.addAll(dayExpensesList)
//                operationsAdapter.notifyDataSetChanged()
//
//
//            },
//            onError = { errorMessage ->
//                Log.e("Error", errorMessage)
//            }
//        )
        getAllTransactions(bearerToken)


        return binding.root
    }

    fun getAllTransactions(bearerToken: String) {
        viewModel.getAllTransactions(
            bearerToken,
            onSuccess = { data ->
                val sortedTransactions = data.transactionsArray
                    .sortedByDescending { it.date }  // Сортируем по убыванию даты
                    .groupBy {
                        val dateTime = DateTimeFormatter.ISO_DATE_TIME.parse(it.date)  // Парсим строку с датой и временем
                        val date = LocalDate.from(dateTime)  // Извлекаем только дату
                        date  // Группируем по дате
                    }

                val dayExpensesList = sortedTransactions.map { (date, transactions) ->
                    val wallet = listWallets.find { it.id == transactions.get(0).walletId }
                    DayExpenses(
                        date = formatDateString(date.toString()),
                        expenses = transactions.map { transaction ->
                            Expense(
                                category = transaction.category.name,
                                description = transaction.description,
                                amount = transaction.amount.toFloat(),
                                icon = transaction.category.icon,
                                wallet = wallet!!.name
                            )
                        }
                    )
                }

                listDaysOperations.clear()
                listDaysOperations.addAll(dayExpensesList)
                operationsAdapter.notifyDataSetChanged()


            },
            onError = { errorMessage ->
                Log.e("Error", errorMessage)
            }
        )
    }


    fun formatDateString(dateString: String): String {
        val formatterInput = DateTimeFormatter.ofPattern("yyyy-MM-dd")  // Входной формат
        val formatterOutput = DateTimeFormatter.ofPattern("d MMMM yyyy")  // Выходной формат

        val date = LocalDate.parse(dateString, formatterInput)  // Парсинг строки в объект LocalDate
        val formattedDate = date.format(formatterOutput)  // Форматирование даты



        return formattedDate
    }

    fun showBottomSheetDialog(listWallets: List<ItemWallet>, accessToken: String?) {
        val dialog = BottomSheetDialog(requireContext(), R.style.BottomSheetDialogTheme)
        val view = layoutInflater.inflate(R.layout.bottom_sheet_new_operation, null)
        val walletNames = listWallets.map { it.name }
        var switchField = true
        var selectedCategory = "Advance"
        var selectedType = "income"
        var selectedWallet = listWallets[0].id
        var selectedItemPosition = 0
        dialog.setCancelable(true)
        dialog.setContentView(view)
        dialog.behavior.state = BottomSheetBehavior.STATE_EXPANDED
        dialog.show()
        val spinner = view.findViewById<Spinner>(R.id.spinner)
        val spinnerCategory = view.findViewById<Spinner>(R.id.spinnerCategory)
        val switch = view.findViewById<SwitchCompat>(R.id.switchType)
        val switchText = view.findViewById<TextView>(R.id.typeOperation)
        val iconCategory = view.findViewById<TextView>(R.id.iconCategory)
        val addButton = view.findViewById<Button>(R.id.addButton)
        val sumOperationText = view.findViewById<EditText>(R.id.sumOperationText)
        val descriptionOperationText = view.findViewById<EditText>(R.id.descriptionOperation)
        iconCategory.text = "\uD83D\uDCB8"

        val categoryIncome = listOf("Advance", "Salary")
        val categoryOutcome = listOf("Food", "Transport", "Shopping", "Medical", "Entertainment", "Miscellaneous", "Housing", "Gym", "Utilities", "Subscription")


        switchText.text = "Доход"
        val adapter = CustomSpinnerAdapter(requireContext(), walletNames, selectedItemPosition)
        spinner.adapter = adapter
        spinner.onItemSelectedListener = object : AdapterView.OnItemSelectedListener {
            override fun onItemSelected(parentView: AdapterView<*>, view: View?, position: Int, id: Long) {
                selectedItemPosition = position
                selectedWallet = listWallets[position].id
                adapter.notifyDataSetChanged()
            }

            override fun onNothingSelected(parentView: AdapterView<*>) {}

        }

        var adapterCategory = CustomSpinnerAdapter(requireContext(), categoryIncome, selectedItemPosition)
        spinnerCategory.adapter = adapterCategory
        spinnerCategory.onItemSelectedListener = object : AdapterView.OnItemSelectedListener {
            override fun onItemSelected(parentView: AdapterView<*>, view: View?, position: Int, id: Long) {
                selectedItemPosition = position

                if (switchField) {
                    selectedCategory = categoryIncome[position]
                    iconCategory.text = categoriesIncome.find { it.name == categoryIncome[position]}!!.icon
                }
                else {
                    selectedCategory = categoryOutcome[position]
                    iconCategory.text = categoriesOutcome.find { it.name == categoryOutcome[position]}!!.icon
                }
                adapter.notifyDataSetChanged()
            }

            override fun onNothingSelected(parentView: AdapterView<*>) {}

        }

        switch.setOnClickListener {
            switchField = !switchField
            if (switchField) {
                switchText.text = "Доход"
                selectedType = "income"
                adapterCategory = CustomSpinnerAdapter(requireContext(), categoryIncome, selectedItemPosition)
                spinnerCategory.adapter = adapterCategory
            }
            else {
                switchText.text = "Расход"
                selectedType = "expense"
                adapterCategory = CustomSpinnerAdapter(requireContext(), categoryOutcome, selectedItemPosition)
                spinnerCategory.adapter = adapterCategory
            }
        }

        addButton.setOnClickListener {
            if (accessToken != null) {
                viewModel.createTransaction(
                    categoryName = selectedCategory,
                    walletId = selectedWallet,
                    amount = sumOperationText.text.toString().toDouble(),
                    type = selectedType,
                    date = LocalDate.now().toString(),
                    description = descriptionOperationText.text.toString(),
                    accessToken = accessToken,
                    onSuccess = { data ->
                        Log.i("Dibug1", data.toString())
                        getAllTransactions(accessToken)
                        dialog.dismiss()
                    },
                    onError = { errorMessage ->
                        Log.i("Dibug1", errorMessage)
                    }
                )
            }
        }
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}