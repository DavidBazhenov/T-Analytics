import { Injectable, BadRequestException, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Transaction } from './schemas/transaction.schema';
import { Wallet } from '../wallets/schemas/wallet.schema';
import { User } from '../auth/user.decorator';

@Injectable()
export class TransactionService {
    constructor(
        @InjectModel('Transaction') private transactionModel: Model<Transaction>,
        @InjectModel('Wallet') private walletModel: Model<Wallet>,
    ) { }

    async createTransaction(@User() user: any, data: Partial<Transaction>) {
        const { walletFromId, walletToId, amount, type, date } = data;
        const transactionData = {
            ...data,
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
        categoryId?: string;
    }) {
        const query: any = { userId: user.sub };

        if (filters.startDate || filters.endDate) {
            query.date = {};
            if (filters.startDate) {
                query.date.$gte = filters.startDate;
            }
            if (filters.endDate) {
                query.date.$lte = filters.endDate;
            }
        }

        if (filters.categoryId) {
            query.categoryId = filters.categoryId;
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
}
