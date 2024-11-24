import random
import pandas as pd
import numpy as np
from datetime import datetime, timedelta
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_absolute_error
from sklearn.ensemble import RandomForestRegressor
from joblib import dump

pd.set_option('display.max_columns', None)  # Отображать все столбцы

# Генерация последовательных дат
def generate_sequential_dates(start_date: datetime, num_days: int) -> list[datetime]:
    return [start_date + timedelta(days=i) for i in range(num_days)]

# Генерация данных для нескольких людей
def generate_financial_data(year, month, num_people=10, num_days=30):
    categories = [
        "Food", "Transport", "Entertainment", "Shopping", "Medical", 
        "Subscriptions", "Dining_out", "Miscellaneous"
    ]
    monthly_categories = ["Housing", "Gym", "Utilities"]
    
    min_salary = 20000
    max_salary = 250000
    min_advance = 10000
    max_advance = 90000
    
    salary_step = (max_salary - min_salary) / num_people
    advance_step = (max_advance - min_advance) / num_people
    
    data = []
    
    for person_id in range(num_people):
        start_date = datetime(year, month, 1)
        dates = generate_sequential_dates(start_date, num_days)
        
        salary = min_salary + salary_step * person_id
        advance = min_advance + advance_step * person_id
        total_balance = 0
        
        for cur_day in dates:
            # Добавление зарплаты
            if cur_day.day == 10:
                data.append({"person_id": person_id, "Date": cur_day, "Amount": salary, "Category": "Salary", "Balance": total_balance})
                total_balance += salary
            # Добавление аванса
            elif cur_day.day == 25:
                data.append({"person_id": person_id, "Date": cur_day, "Amount": advance, "Category": "Advance", "Balance": total_balance})
                total_balance += advance
            
            # Случайные расходы
            expense_count = random.randint(1, 3)
            for _ in range(expense_count):
                category = random.choice(categories)
                amount = random.uniform(10, min(total_balance / 3, 1000))
                total_balance -= amount
                if total_balance > 0:
                    data.append({"person_id": person_id, "Date": cur_day, "Amount": -amount, "Category": category, "Balance": total_balance})
            
            # Раз в месяц
            if random.random() < 0.05:
                category = random.choice(monthly_categories)
                amount = random.uniform(10, min(total_balance / 5, 2000))
                total_balance -= amount
                if total_balance > 0:
                    data.append({"person_id": person_id, "Date": cur_day, "Amount": -amount, "Category": category, "Balance": total_balance})
    
    return pd.DataFrame(data)

# Генерация данных
data = generate_financial_data(2024, 1, num_people=60, num_days=75)

# Создание дополнительных признаков
data['Date_numeric'] = (data['Date'] - data['Date'].min()).dt.days
data['Amount_abs'] = data['Amount'].abs()  # Абсолютная сумма транзакции
data['Is_income'] = (data['Amount'] > 0).astype(int)  # Доход или расход
data['Day_of_week'] = data['Date'].dt.dayofweek  # День недели (0 - Пн, 6 - Вс)
data['Week_of_month'] = data['Date'].dt.day // 7  # Неделя месяца
data = pd.get_dummies(data, columns=['Category'], drop_first=True)  # One-hot encoding категорий

# Признаки и целевая переменная
X = data.drop(columns=['Date', 'Amount'])
y = data['Amount']

# Разделение на обучающую и тестовую выборки
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)


model = RandomForestRegressor(n_estimators=200, max_depth=15, random_state=42)
model.fit(X_train, y_train)

dump(model, 'mlp_model_4.joblib')

# Оценка модели
y_pred = model.predict(X_test).tolist()
mae = mean_absolute_error(y_test, y_pred)
print(f"Mean Absolute Error: {mae}")

# Пример сравнения прогнозов с реальными данными
result_df = X_test.copy()
result_df['Actual'] = y_test
result_df['Predicted'] = y_pred
# print(result_df.head())