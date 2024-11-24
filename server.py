from fastapi import FastAPI, HTTPException, Request
from pydantic import BaseModel
from joblib import load
import pandas as pd

app = FastAPI()
model = None

@app.get("/")
async def read_root():
    return {"message": "Hello, World!"}


@app.on_event("startup")
async def load_model():
    """
    Загружает модель при запуске приложения.
    """
    print("START SERVER")
    global model
    try:
        # Загрузка модели
        model = load('mlp_model_4.joblib')
        print(model)
        # Проверка, что модель загружена
        if model is None:
            raise HTTPException(status_code=501, detail="Model not loaded properly")


    except Exception as e:
        raise HTTPException(status_code=502, detail="Error loading model")


# Модель ответа
class NeuralNetResponse(BaseModel):
    predictions: list  # Список предсказаний


@app.post("/predict/")
async def get_predictions(request: Request):
    try:
        # Извлекаем тело запроса
        body = await request.json()
        # Проверяем, что тело не пустое
        if not body:
            raise HTTPException(status_code=400, detail="Empty request body")
        else:
            data = []
            
            try:
                for item in body:
                    if ('Date' in item) and ('Amount' in item) and ('Category' in item):
                        data.append({"Date" : item['Date'], "Amount" : item['Amount'], "Category" : item['Category']})
                
                if len(data) == 0: 
                    HTTPException(status_code=503, detail='No currect json in list')
            except Exception as e:
                pass
                
            try:
                predicted_data = predict_future_income(data)
                for i in range(len(body)): body[i]['Amount'] = predicted_data[i]
                return NeuralNetResponse(predictions=body)
            except Exception as e:
                HTTPException(status_code=504, detail='Error during prediction')           
    except HTTPException as e:
        pass 


def predict_future_income(data : list[dict]) -> list:
    df = pd.DataFrame(data)
    # Добавление признаков
    df['person_id'] = 0
    df['Date'] = pd.to_datetime(df['Date']) 
    df['Date_numeric'] = (df['Date'] - df['Date'].min()).dt.days
    df['Amount_abs'] = df['Amount'].abs()
    df['Is_income'] = (df['Amount'] > 0).astype(int)
    df['Day_of_week'] = df['Date'].dt.dayofweek
    df['Week_of_month'] = df['Date'].dt.day // 7

    # One-hot encoding для категории
    df = pd.get_dummies(df, columns=['Category'], drop_first=True)

    # Полный список признаков, которые ожидала модель
    expected_features = [
        'person_id', 'Balance', 'Date_numeric', 'Amount_abs', 'Is_income', 
        'Day_of_week', 'Week_of_month', 'Category_Dining_out', 'Category_Entertainment', 
        'Category_Food', 'Category_Gym', 'Category_Housing', 'Category_Medical', 
        'Category_Miscellaneous', 'Category_Salary', 'Category_Shopping', 
        'Category_Subscriptions', 'Category_Transport', 'Category_Utilities'
    ]

    # Убедимся, что все пропущенные столбцы добавлены
    for feature in expected_features:
        if feature not in df.columns:
            df[feature] = 0  

    # Убедимся, что используем только признаки, ожидаемые моделью
    X_new = df[expected_features]

    # Предсказание
    predictions = model.predict(X_new).tolist()
    
    return predictions