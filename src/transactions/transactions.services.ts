import { Injectable, BadRequestException, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Transaction } from './schemas/transaction.schema';
import { Wallet } from '../wallets/schemas/wallet.schema';
import { User } from '../auth/user.decorator';
import axios from 'axios';

@Injectable()
export class TransactionService {
  constructor(
    @InjectModel('Transaction') private transactionModel: Model<Transaction>,
    @InjectModel('Wallet') private walletModel: Model<Wallet>,
  ) { }

  private createCategory(CategoryName: string): { name: string, icon: string, color: string } {
    if (CategoryName === 'Food') {
      return {
        name: 'Food',
        icon: '🍔',
        color: '#FF5722',
      };
    } else if (CategoryName === 'Transport') {
      return {
        name: 'Transport',
        icon: '🚗',
        color: '#FF5722',
      };
    } else if (CategoryName === 'Entertainment') {
      return {
        name: 'Entertainment',
        icon: '🎉',
        color: '#FF5722',
      };
    } else if (CategoryName === 'Advance') {
      return {
        name: 'Advance',
        icon: '💸',
        color: '#FF5722',
      };
    } else if (CategoryName === 'Salary') { // Исправлено из "name" на "CategoryName"
      return {
        name: 'Salary',
        icon: '💰',
        color: '#FF5722',
      };
    }
    // Значение по умолчанию
    return {
      name: 'Food',
      icon: '🛒',
      color: '#FF5722',
    };
  }


  async createTransaction(@User() user: any, data: Partial<Transaction>) {
    const { walletFromId, walletToId, amount, type, date } = data;

    if (data.category.name !== 'Food' && data.category.name !== 'Transport' && data.category.name !== 'Entertainment' && data.category.name !== 'Advance' && data.category.name !== 'Salary') {
      return { data: {}, error: 'Неправильная категория', success: false };
    }
    const transactionData = {
      ...data,
      category: this.createCategory(data.category.name),
      date: date || new Date().toISOString().split('T')[0],
      userId: user.sub,
    };
    // Проверяем кошельки (если указаны)
    const walletFrom = walletFromId
      ? await this.walletModel.findOne({ _id: walletFromId, userId: user.sub })
      : null;
    const walletTo = walletToId
      ? await this.walletModel.findOne({ _id: walletToId, userId: user.sub })
      : null;

    // Проверка наличия кошельков
    if (!walletFrom) {
      return { data: {}, error: 'Кошелек отправителя не найден', success: false };
    }

    // Проверка наличия кошелька получателя
    if (!walletTo && type === 'transfer') {
      return { data: {}, error: 'Кошелек получателя не указан', success: false };
    }

    if (walletFrom && walletTo && walletFrom.currency !== walletTo.currency) {
      return { data: {}, error: 'Валюты кошельков не совпадают', success: false };
    }

    if (type === 'expense' && walletFrom) {
      if (walletFrom.balance < amount) {
        return { data: {}, error: 'Недостаточно средств на кошельке', success: false };
      }
      walletFrom.balance -= amount;
      await walletFrom.save();
    } else if (type === 'income' && walletFrom) {
      walletFrom.balance += amount;
      await walletFrom.save();
    } else if (type === 'transfer' && walletFrom && walletTo) {
      if (walletFrom.balance < amount) {
        return { data: {}, error: 'Недостаточно средств на кошельке отправителя', success: false };
      }
      walletFrom.balance -= amount;
      walletTo.balance += amount;
      await walletFrom.save();
      await walletTo.save();
    }

    const transaction = new this.transactionModel(transactionData);
    await transaction.save()
    return { data: { transaction }, error: '', success: true };
  }

  async updateTransaction(
    transactionId: string,
    data: Partial<Transaction>,
  ) {
    const transaction = await this.transactionModel.findById(transactionId);
    if (!transaction) {
      return { data: {}, error: 'Транзакция не найдена', success: false };
    }

    await this.deleteTransaction(transactionId);
    const newTransactionData = {
      ...data,
      date: data.date || new Date().toISOString().split('T')[0],
    };
    return { data: { newTransactionData }, error: '', success: true };
  }

  async deleteTransaction(transactionId: string) {
    const transaction = await this.transactionModel.findById(transactionId);
    if (!transaction) {
      return { data: {}, error: 'Транзакция не найдена', success: false };
    }

    // Возвращаем баланс кошельков
    const { walletFromId, walletToId, amount, type } = transaction;
    const walletFrom = walletFromId
      ? await this.walletModel.findById(walletFromId)
      : null;
    const walletTo = walletToId
      ? await this.walletModel.findById(walletToId)
      : null;

    if (type === 'expense' && walletFrom) {
      walletFrom.balance += amount;
      await walletFrom.save();
    } else if (type === 'income' && walletFrom) {
      walletFrom.balance -= amount;
      await walletFrom.save();
    } else if (type === 'transfer' && walletFrom && walletTo) {
      walletFrom.balance += amount;
      walletTo.balance -= amount;
      await walletFrom.save();
      await walletTo.save();
    }

    await transaction.deleteOne();
    return { data: {}, error: '', success: true };
  }

  async getTransactions(@User() user: any, filters: {
    startDate?: Date;
    endDate?: Date;
    category?: {
      name: string;
    }
  }) {
    const query: any = { userId: user.sub };
    console.log(filters);

    if (filters.startDate || filters.endDate) {
      query.date = {};
      if (filters.startDate) {
        query.date.$gte = filters.startDate;
      }
      if (filters.endDate) {
        query.date.$lte = filters.endDate;
      }
    }

    if (filters && filters.category && filters.category.name) {
      query.category.name = filters.category.name;
    }

    try {
      const transactions = await this.transactionModel.find(query).exec();
      return { data: { transactions }, error: '', success: true };
    } catch (error) {
      return { data: {}, error: error.message, success: false };
    }
  }

  async getAllWalletsTransactions(@User() user: any) {
    const query: any = { userId: user.sub };

    try {
      const transactions = await this.transactionModel.find(query).exec();
      const transactionsMap: { [walletId: string]: Transaction[] } = {};
      transactions.forEach(transaction => {
        if (!transactionsMap[transaction.walletFromId]) {
          transactionsMap[transaction.walletFromId] = [];
        }
        transactionsMap[transaction.walletFromId].push(transaction);
      });

      const transactionsArray = Object.values(transactionsMap);
      return { data: { transactionsArray }, error: '', success: true };
    } catch (error) {
      return { data: {}, error: error.message, success: false };
    }
  }

  async getPredictTransactions(@User() user: any) {
    const query: any = { userId: user.sub };

    try {
      const transactions = await this.transactionModel.find(query).exec();



      const transactionsArray = Object.values(transactions).map(walletTransactions => {
        return {
          Date: walletTransactions.date.toISOString().split('T')[0],
          Amount: walletTransactions.amount, // Поле суммы транзакции
          Category: walletTransactions.category.name, // Поле категории транзакции
        }
      });
      console.log(transactionsArray);

      // Отправляем данные на сервер для предсказания
      const response = await axios.post('http://194.87.202.4:8000/predict/', transactionsArray);
      console.log(response);

      // Возвращаем результат от API
      return {
        data: response.data,
        error: '',
        success: true,
      };
    } catch (error) {
      return {
        data: {},
        error: error.message,
        success: false,
      };
    }
  }
}
