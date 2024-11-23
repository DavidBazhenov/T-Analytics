import pandas as pd
import numpy as np
from joblib import dump

# варианты моделей
from sklearn.ensemble import GradientBoostingRegressor
from generation_data import Generate_data
from sklearn.linear_model import LinearRegression 

from sklearn.model_selection import train_test_split  # Для разделения данных на обучающую и тестовую выборку
from sklearn.metrics import mean_squared_error, r2_score, mean_absolute_error  # Для оценки качества модели

pd.set_option('display.max_rows', None)  # Отображать все строки
pd.set_option('display.max_columns', None)  # Отображать все столбцы

class ML_block_education:
    def __init__(self, data : Generate_data) -> None:
        self.data = data
        self.exclude_substrings = ['Transact to', 'Transact from']
        
        
    def prediction_for_current_person(self, person_index : int) -> None:
        self.person_dataFrame = self.data.get_persons_dataFrame(person_index)
        self.set_analyzed_categories()
        self.df_filtered_with_dummies = self.set_dummies(self.person_dataFrame)
        self.X, self.y = self.set_X_y(self.df_filtered_with_dummies)
        self.education()
        # self.prediction()
        
        
        
    def set_analyzed_categories(self) -> None:
        self.person_categories = self.person_dataFrame['Category'].unique()
        
        self.analyzed_categories = [
            category for category in self.person_categories
            if not any(sub in category for sub in self.exclude_substrings)
        ]
        
    def set_dummies(self, dataFrame : pd.DataFrame, mode=False) -> pd.DataFrame:
        # создание отфильтрованного dataframe
        df_filtered = dataFrame[dataFrame['Category'].isin(self.analyzed_categories)]
        
        # Создание категориальных признаков по отфильтрованному датафрейму
        df_filtered_with_dummies = pd.get_dummies(df_filtered, columns=['Category'], prefix='Cat')
        
        if mode: self.df_filtered = df_filtered
        return df_filtered_with_dummies
        
    def set_X_y(self, df_with_dummies : pd.DataFrame) -> tuple[pd.DataFrame, pd.Series]:
        cat_columns = [cat for cat in df_with_dummies.columns if cat.startswith("Cat_")]

        # формирование матрицы признаков
        X = self.df_filtered_with_dummies[cat_columns]
        print(X)
        # целевая переменная
        y = self.df_filtered_with_dummies['Amount']
        print(y)
        return X, y
        
        
    def education(self) -> None:
        X_train, X_test , y_train, y_test = train_test_split(self.X, self.y, test_size=0.2, random_state=42, shuffle=True)
        self.model = LinearRegression()
        self.model.fit(X_train, y_train)
        
        y_pred = self.model.predict(X_test)
        
        mae = mean_absolute_error(y_test, y_pred)
        mse = mean_squared_error(y_test, y_pred)
        rmse = np.sqrt(mse)
        r2 = r2_score(y_test, y_pred)
        
        print(f'mae = {mae}')
        print(f'mse = {mse}')
        print(f'rmse = {rmse}')
        print(f'r2 = {r2}')
        
        dump(self.model, 'mlp_model.joblib')
        
        
        
        
    def prediction(self) -> None:
        df_dummies = self.set_dummies(self.person_dataFrame, mode=True)
        
        cat_columns_future = [cat for cat in df_dummies.columns if cat.startswith("Cat_")]
        X_future = df_dummies[cat_columns_future]
        
        amount_predicted = self.model.predict(X_future)
        self.df_filtered['Amount_predicted'] = amount_predicted
        
        print(self.df_filtered)
    
    
if __name__ == "__main__":
    data = Generate_data(5, 120)   
    
    ml_block = ML_block_education(data)
    ml_block.prediction_for_current_person(person_index=0)
    


# # 1) Пример данных

# # Список категорий
# categories = ['Transport', 'Food', 'Salary', 'Entertainment', 'advance', 'transaction to Pupkin', 'transaction from Pupkin']

# # Генерация данных
# num_rows = 100
# data = {
#     'Date': pd.date_range(start='2024-01-01', periods=num_rows, freq='D'),
#     'Amount': [random.randint(-3000, 30000) for _ in range(num_rows)],  # случайные суммы от -3000 до 30000
#     'Category': [random.choice(categories) for _ in range(num_rows)]   # случайный выбор категорий
# }

# # data = {
# #     'Date':     ['2024-01-01', '2024-01-02', '2024-01-03',  '2024-01-04',   '2024-01-05', '2024-01-06',     '2024-01-06',          '2024-01-07',    '2024-01-08',        '2024-01-08'],
# #     'Amount':   [  -500,         -1200,         30000,         -300,             -700,       -1000,            -3000,                   10000,          2000,               -600],
# #     'Category': ['Transport',  'Food',       'Salary',     'Entertainment',   'Food',     'Transport',   'transaction to Pupkin',  'advance',    'transaction to Pupkin',   'Food']
# # }
# df = pd.DataFrame(data)

# # 2) Преобразование даты
# df['Date'] = pd.to_datetime(df['Date'])


# # 3) создание категориальных признаков
# #   3.1) выделение уникальных признаков
# categories = df['Category'].unique()

# #   3.2) список категорий, которые не входят в анализ
# exclude_substrings = ['transaction to', 'transaction from']

# #   3.3) список категорий, которые входят в анализ
# useful_categories = [
#     category for category in categories
#     if not any(sub in category for sub in exclude_substrings)
# ]

# #   3.4) создание отфильтрованного dataframe
# df_filtered = df[df['Category'].isin(useful_categories)]

# #   3.5) Создание категориальных признаков по отфильтрованному датафрейму
# df_filtered_with_dummies = pd.get_dummies(df_filtered, columns=['Category'], prefix='Cat')

# # 4) Создание матрицы признаков и целевой переменной
# #   4.1) выбор всех Cat столбцов для создания матрицы признаков
# cat_columns = [cat for cat in df_filtered_with_dummies.columns if cat.startswith("Cat_")]

# #   4.2) формирование матрицы признаков
# X = df_filtered_with_dummies[cat_columns]

# #   4.3) целевая переменная
# y = df_filtered_with_dummies['Amount']


# # 5) обучение и предсказание
# #   5.1) Данные для тестирования и обучения
# X_train, _, y_train, _ = train_test_split(X, y, test_size=0.2, random_state=42, shuffle=True)

# #   5.2) Обучение
# model = LinearRegression()
# model.fit(X_train, y_train)

# #   5.3) Предсказание
# future_data = {
#     'Date': pd.date_range(start='2024-02-01', periods=30, freq='D'),
#     'Category': random.choices(useful_categories, k=30)
# }
# df_future = pd.DataFrame(future_data)
# df_future_with_dummies = pd.get_dummies(df_future, columns=["Category"], prefix="Cat")

# cat_columns_future = [cat for cat in df_filtered_with_dummies.columns if cat.startswith("Cat_")]
# X_future = df_future_with_dummies[cat_columns_future]

# y_pred = model.predict(X_future)

# df_future['Amount'] = y_pred

# print('current dataframe = ')
# print(df)
# print()
# print('future predicted dataframe = ')
# print(df_future)
