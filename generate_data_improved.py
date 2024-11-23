import random
import pandas as pd
from datetime import datetime, timedelta

pd.set_option('display.max_rows', None)  # Отображать все строки
pd.set_option('display.max_columns', None)  # Отображать все столбцы

# Функция для генерации последовательных дат от start_date на количество дней
def generate_sequential_dates(start_date, num_days):
    date_list = []
    for i in range(num_days):
        date_list.append((start_date + timedelta(days=i)).strftime('%Y-%m-%d'))
    return date_list

# Функция для генерации данных для нескольких людей
def generate_financial_data_for_multiple_people(year, month, num_people=10, num_days=30):
    categories = [
        "Housing", "Food", "Transport", "Entertainment", "Shopping", "Medical", "Subscriptions", 
        "Utilities", "Gym", "Dining out", "Miscellaneous"
    ]
    
    data = []
    
    for person_id in range(1, num_people + 1):
        # Плавное изменение зарплаты и аванса для каждого человека
        min_salary = 1000000
        max_salary = 10000
        min_advance = 10000
        max_advance = 1000000
        
        # Плавное увеличение зарплаты и аванса
        salary_step = (max_salary - min_salary) / num_days
        advance_step = (max_advance - min_advance) / num_days
        
        # Инициализируем словарь для текущего человека
        person_data = {
            'Date': [],
            'Amount': [],
            'Category': []
        }
        
        # Генерация последовательных дат
        start_date = datetime(year, month, 1)
        dates = generate_sequential_dates(start_date, num_days)
        
        for entry in range(1, num_days + 1):
            # Определяем текущую зарплату и аванс для данного человека
            salary = min_salary + salary_step * entry
            advance = min_advance + advance_step * entry
            
            # Генерация поступлений (Salary и Advance)
            num_transactions = random.randint(1, 3)  # Минимум 1, максимум 3 поступления в месяц
            for _ in range(num_transactions):
                date = random.choice(dates)
                person_data['Date'].append(date)
                person_data['Amount'].append(salary if random.random() < 0.7 else advance)  # 70% шанс на зарплату
                person_data['Category'].append("Salary" if random.random() < 0.7 else "Advance")
            
            # Генерация трат (негативные суммы)
            total_balance = salary + advance
            expense_count = random.randint(5, 40)  # Случайное количество трат в месяц
            
            for _ in range(expense_count):
                expense_date = random.choice(dates)  # Траты могут быть в те же дни, что и поступления
                category = random.choice(categories)
                amount = random.uniform(10, total_balance / 3)  # Размер траты
                total_balance -= amount  # Обновляем остаток после траты
                person_data['Date'].append(expense_date)
                person_data['Amount'].append(-amount)  # Трата уменьшает баланс
                person_data['Category'].append(category)
            
            # Генерация переводов
            num_transacts = random.randint(0, 4)  # от 0 до 4 перевода в месяц
            for _ in range(num_transacts):
                trans_date = random.choice(dates)
                if random.random() < 0.5:  # 50% шанс на транзакцию
                    person_data['Date'].append(trans_date)
                    person_data['Amount'].append(-random.uniform(100, 1000))  # Перевод кому-то (уменьшение)
                    person_data['Category'].append("Transact to")
                else:
                    person_data['Date'].append(trans_date)
                    person_data['Amount'].append(random.uniform(100, 1000))  # Перевод от кого-то (увеличение)
                    person_data['Category'].append("Transact from")
        
        # Добавляем данные текущего человека в общий список
        data.append({person_id: person_data})
    
    return data


if __name__ == "__main__":
    # Генерация данных для 10 людей за Январь 2024 (30 дней)
    data = generate_financial_data_for_multiple_people(2024, 1, num_people=50, num_days=75)

    # Показать структуру данных для первого человека
    df = pd.DataFrame(data[0][1])
    print(df)
