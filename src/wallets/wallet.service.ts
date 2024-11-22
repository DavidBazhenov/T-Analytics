import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Wallet } from './schemas/wallet.schema';
import { CreateWalletDto } from './dto/create-wallet.dto';
import { UpdateWalletDto } from './dto/update-wallet.dto';

@Injectable()
export class WalletService {
    constructor(
        @InjectModel('Wallet') private readonly walletModel: Model<Wallet>,
    ) { }

    // Создание нового кошелька
    async create(createWalletDto: CreateWalletDto): Promise<Wallet> {
        const createdWallet = new this.walletModel(createWalletDto);  // Передаем DTO с userId
        return createdWallet.save();
    }


    // Получение кошельков по userId
    async findAllByUserId(userId: string): Promise<Wallet[]> {
        return this.walletModel.find({ userId }).exec();
    }

    // Получение кошелька по ID
    async findOneById(id: string): Promise<Wallet> {
        return this.walletModel.findById(id).exec();
    }

    // Обновление кошелька
    async update(id: string, updateWalletDto: UpdateWalletDto): Promise<Wallet> {
        return this.walletModel.findByIdAndUpdate(id, updateWalletDto, { new: true }).exec();
    }

    // Удаление кошелька
    async remove(id: string): Promise<any> {
        return this.walletModel.findByIdAndDelete(id).exec();
    }
}
