import { Controller, Post, Get, Param, Body, Put, Delete, UseGuards } from '@nestjs/common';
import { WalletService } from './wallet.service';
import { CreateWalletDto } from './dto/create-wallet.dto';
import { UpdateWalletDto } from './dto/update-wallet.dto';
import { Wallet } from './schemas/wallet.schema';
import { AuthGuard } from '../auth/auth.guard';

@Controller('wallets')
export class WalletController {
    constructor(private readonly walletService: WalletService) { }

    // Создание нового кошелька
    @UseGuards(AuthGuard)
    @Post()
    async create(@Body() createWalletDto: CreateWalletDto): Promise<Wallet> {
        return this.walletService.create(createWalletDto);
    }

    // Получение всех кошельков пользователя по userId
    @UseGuards(AuthGuard)
    @Get('user/:userId')
    async findAllByUserId(@Param('userId') userId: string): Promise<Wallet[]> {
        return this.walletService.findAllByUserId(userId);
    }

    // Получение кошелька по его ID
    @UseGuards(AuthGuard)
    @Get(':id')
    async findOne(@Param('id') id: string): Promise<Wallet> {
        return this.walletService.findOneById(id);
    }

    // Обновление данных кошелька
    @UseGuards(AuthGuard)
    @Put(':id')
    async update(
        @Param('id') id: string,
        @Body() updateWalletDto: UpdateWalletDto,
    ): Promise<Wallet> {
        return this.walletService.update(id, updateWalletDto);
    }

    // Удаление кошелька
    @UseGuards(AuthGuard)
    @Delete(':id')
    async remove(@Param('id') id: string): Promise<any> {
        return this.walletService.remove(id);
    }
}
