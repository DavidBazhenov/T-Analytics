from fastapi import FastAPI, HTTPException, Request
from pydantic import BaseModel
from joblib import load
import pandas as pd
from consts import analyzed_categories

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
        model = load('mlp_model.joblib')
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
    print("HANDLE POST")
    """
    Обрабатывает POST-запрос, принимает массив JSON, проверяет его, отправляет данные нейросети и возвращает результат.
    """
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
    cur_columns = df.columns
    last_date = df.iloc[-1]['Date']
    for cat in analyzed_categories:
        if not(cat in cur_columns): 
            new_row = {'Date': last_date, 'Amount': 0, 'Category': cat}
            df = pd.concat([df, pd.DataFrame([new_row])], ignore_index=True)
    
    
    df_dummies = pd.get_dummies(df, columns=['Category'], prefix='Cat')
    cats_cur = [cat for cat in df_dummies.columns if cat.startswith("Cat_")]
    
    X = df_dummies[cats_cur]
    print()
    print('X =')
    print(X)
    y_pred = model.predict(X)
    print(y_pred)
    # Возвращаем предсказания как список
    return y_pred.tolist()