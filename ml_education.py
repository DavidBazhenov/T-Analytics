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
        
        # целевая переменная
        y = self.df_filtered_with_dummies['Amount']
        
        return X, y
        
        
    def education(self) -> None:
        X_train, X_test , y_train, y_test = train_test_split(self.X, self.y, test_size=0.2, random_state=42, shuffle=True)
        self.model = LinearRegression()
        self.model.fit(X_train, y_train)
        print(self.model)
        
        y_pred = self.model.predict(X_test)
        
        mae = mean_absolute_error(y_test, y_pred)
        mse = mean_squared_error(y_test, y_pred)
        rmse = np.sqrt(mse)
        r2 = r2_score(y_test, y_pred)
        
        # print(f'mae = {mae}')
        # print(f'mse = {mse}')
        # print(f'rmse = {rmse}')
        # print(f'r2 = {r2}')
        
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