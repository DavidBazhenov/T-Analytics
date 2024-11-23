import pandas as pd
import random

pd.set_option('display.max_rows', None)  # Отображать все строки
pd.set_option('display.max_columns', None)  # Отображать все столбцы


class Generate_data:
    def __init__(self, num_people : int, num_days : int) -> None:
        # Список категорий не включая зарплату и аванс
        self._categories = ['Transport', 'Food', 'Entertainment', 'Transact to', 'Transact from']

        self._num_people = num_people  
        self._num_days   = num_days  
        
        self._start_date  = '2024-01-01'
        self._salary_day  = pd.Timestamp(self._start_date).day + pd.Timedelta(days=9).days
        self._advance_day = pd.Timestamp(self._start_date).day + pd.Timedelta(days=24).days

        self._people = [f'Person_{i+1}' for i in range(self._num_people)]
        self._persons_data = []
        
        self.set_person_params()
        self.generate_peoples_data()
        self.set_dataframes()
        
      
    def set_person_params(self) -> None: 
        self.person_params = {
            person: {
                'salary_mean': random.randint(25000, 40000),
                'salary_std': random.randint(3000, 7000),
                'food_mean': random.randint(400, 700),
                'food_std': random.randint(100, 300),
                'transport_mean': random.randint(200, 400),
                'transport_std': random.randint(50, 150),
                'entertainment_mean': random.randint(800, 1500),
                'entertainment_std': random.randint(300, 600),
                'advance_mean': random.randint(10000, 20000),
                'advance_std': random.randint(4000, 6000),
                'transact_to_mean': random.randint(10000, 20000),
                'transact_to_std': random.randint(4000, 6000),
                'transact_from_mean': random.randint(10000, 20000),
                'transact_from_std': random.randint(4000, 6000),  
            }
            for person in self._people
        }
    
    # функция для генерации инфомации по людям 
    def generate_peoples_data(self) -> None:
        for person in self._people:
            params = self.person_params[person]
            data = []
            
            for i in range(self._num_days):
                date = pd.Timestamp(self._start_date) + pd.Timedelta(days=i)
            
                for category in random.choices(self._categories, k=random.randint(1, 4)):
                    amount = self.generate_amount(category, date, params)

                    if amount == 0: pass
                    else: data.append({'Person': person, 'Date': date, 'Amount': amount, 'Category': category})
                
                if   date.day == self._salary_day:  
                    amount = self.generate_amount('Salary', date, params)
                    data.append({'Person': person, 'Date': date, 'Amount': amount, 'Category': 'Salary'})
                elif date.day == self._advance_day: 
                    amount = self.generate_amount('Advance', date, params)
                    data.append({'Person': person, 'Date': date, 'Amount': amount, 'Category': 'Advance'})
            
            self._persons_data.append(data)
    
    
    def set_dataframes(self) -> None:
        self.persons_dfs = [pd.DataFrame(data) for data in self._persons_data]
    
    
    # Функции для генерации сумм
    def generate_amount(self, category : str, date : pd.Timestamp, params : dict):
        is__salary_day  = date.day == self._salary_day
        is_advance_day = date.day == self._advance_day
        sign = 1 if category in ['Salary', 'Advance', 'Transact from'] else -1 
        
        if category == 'Salary':
            while True:
                value = random.gauss(params['salary_mean'], params['salary_std']) 
                if value != 0 : break
        elif category == 'Advance':
            while True:
                value = random.gauss(params['salary_mean'], params['salary_std'])
                if value != 0 : break
        elif category == 'Food':
            base = random.gauss(params['food_mean'], params['food_std'])
            if self.is_holiday(date): base *= 1.3
            if is__salary_day or is_advance_day: base *= 1.5
            value = base
        elif category == 'Transport':
            base = random.gauss(params['transport_mean'], params['transport_std'])
            if self.is_holiday(date): base *= 0.5
            value = base
        elif category == 'Entertainment':
            base = random.gauss(params['entertainment_mean'], params['entertainment_std'])
            if self.is_holiday(date): base *= 1.5
            if random.random() < 0.1: base *= 2
            value = base
        elif category == 'Transact to':
            value = random.gauss(params['transact_to_mean'], params['transact_to_std'])
        elif category == 'Transact from':
            value = random.gauss(params['transact_from_mean'], params['transact_from_std'])
            
        if (value > 0 and sign == -1) or (value < 0 and sign == 1): value *= -1
        return value
    
            
    # Функция для определения праздничных дней
    def is_holiday(self, date : pd.Timestamp):
        return date.month == 12 or date.dayofweek >= 5

    
    def get_persons_data(self, index : int) -> dict:
        return self._persons_data[index]
        
    def get_persons_dataFrame(self, index : int) -> pd.DataFrame:
        return self.persons_dfs[index]
    

if __name__ == "__main__":
    data = Generate_data(10, 60)
    print(data.get_persons_dataFrame(0))


# # Список категорий не включая зарплату и аванс
# _categories = ['Transport', 'Food', 'Entertainment', 'Transact to', 'Transact from']

# # Параметры генерации
# _num_people = 5  # Для примера 5 человек
# num_rows = 30  # 30 дней данных для простоты
# _start_date = '2024-01-01'

# _salary_day  = pd.Timestamp(_start_date).day + pd.Timedelta(days=9).days
# _advance_day = pd.Timestamp(_start_date).day + pd.Timedelta(days=24).days

# # Генерация случайных имен для людей
# _people = [f'Person_{i+1}' for i in range(_num_people)]

# # Функция для определения праздничных дней
# def is_holiday(date : pd.Timestamp):
#     return date.month == 12 or date.dayofweek >= 5

# # Функции для генерации сумм
# def generate_amount(category : str, date : pd.Timestamp, params : dict):
#     is__salary_day  = date.day == _salary_day
#     is_advance_day = date.day == _advance_day
#     sign = 1 if category in ['Salary', 'Advance', 'Transact from'] else -1 
    
#     if category == 'Salary':
#         while True:
#             value = random.gauss(params['salary_mean'], params['salary_std']) 
#             if value != 0 : break
#     elif category == 'Advance':
#         while True:
#             value = random.gauss(params['salary_mean'], params['salary_std'])
#             if value != 0 : break
#     elif category == 'Food':
#         base = random.gauss(params['food_mean'], params['food_std'])
#         if is_holiday(date): base *= 1.3
#         if is__salary_day or is_advance_day: base *= 1.5
#         value = base
#     elif category == 'Transport':
#         base = random.gauss(params['transport_mean'], params['transport_std'])
#         if is_holiday(date): base *= 0.5
#         value = base
#     elif category == 'Entertainment':
#         base = random.gauss(params['entertainment_mean'], params['entertainment_std'])
#         if is_holiday(date): base *= 1.5
#         if random.random() < 0.1: base *= 2
#         value = base
#     elif category == 'Transact to':
#         value = random.gauss(params['transact_to_mean'], params['transact_to_std'])
#     elif category == 'Transact from':
#         value = random.gauss(params['transact_from_mean'], params['transact_from_std'])
        
#     if (value > 0 and sign == -1) or (value < 0 and sign == 1): value *= -1
#     return value
        

# # Генерация параметров для каждого человека
# person_params = {
#     person: {
#         'salary_mean': random.randint(25000, 40000),
#         'salary_std': random.randint(3000, 7000),
#         'food_mean': random.randint(400, 700),
#         'food_std': random.randint(100, 300),
#         'transport_mean': random.randint(200, 400),
#         'transport_std': random.randint(50, 150),
#         'entertainment_mean': random.randint(800, 1500),
#         'entertainment_std': random.randint(300, 600),
#         'advance_mean': random.randint(10000, 20000),
#         'advance_std': random.randint(4000, 6000),
#         'transact_to_mean': random.randint(10000, 20000),
#         'transact_to_std': random.randint(4000, 6000),
#         'transact_from_mean': random.randint(10000, 20000),
#         'transact_from_std': random.randint(4000, 6000),  
#     }
#     for person in _people
# }

# _persons_data = []

# for person in _people:
#     params = person_params[person]
#     last_salary_date = pd.Timestamp(_start_date) + pd.Timedelta(days=9)
#     last_advance_date = pd.Timestamp(_start_date) + pd.Timedelta(days=24)
#     data = []
    
#     for i in range(num_rows):
#         date = pd.Timestamp(_start_date) + pd.Timedelta(days=i)
       
#         for category in random.choices(_categories, k=random.randint(1, 4)):
#             amount = generate_amount(category, date, params)

#             if amount == 0: pass
#             else: data.append({'Person': person, 'Date': date, 'Amount': amount, 'Category': category})
        
#         if   date.day == _salary_day:  
#             amount = generate_amount('Salary', date, params)
#             data.append({'Person': person, 'Date': date, 'Amount': amount, 'Category': 'Salary'})
#         elif date.day == _advance_day: 
#             amount = generate_amount('Advance', date, params)
#             data.append({'Person': person, 'Date': date, 'Amount': amount, 'Category': 'Advance'})
    
#     _persons_data.append(data)

# persons_dfs = [pd.DataFrame(data) for data in _persons_data]

# print(persons_dfs[0])
