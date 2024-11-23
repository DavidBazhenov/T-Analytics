import numpy as np
import torch
from torch.utils.data import Dataset, DataLoader

# Пример данных: доходы, траты, категории расходов
data = [
    {"user_id": 1, "income": 3000, "expense": 2000, "category_food": 500, "category_rent": 1200, "expense_next": 2100},
    {"user_id": 1, "income": 3200, "expense": 2100, "category_food": 600, "category_rent": 1300, "expense_next": 2200},
    # Добавьте данные для других пользователей
]

# Группируем данные по пользователям
def prepare_data(data, window_size=3):
    sequences = []
    targets = []

    users = set([d["user_id"] for d in data])
    for user_id in users:
        user_data = [d for d in data if d["user_id"] == user_id]

        for i in range(len(user_data) - window_size):
            window = user_data[i:i + window_size]
            target = user_data[i + window_size]["expense_next"]

            # Формируем признаки из окна
            features = [[d["income"], d["expense"], d["category_food"], d["category_rent"]] for d in window]
            sequences.append(features)
            targets.append(target)

    return np.array(sequences, dtype=np.float32), np.array(targets, dtype=np.float32)

# Пример подготовки данных
X, y = prepare_data(data, window_size=3)