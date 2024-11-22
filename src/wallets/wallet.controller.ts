import { Controller, Post, Get, Param, Body, Put, Delete, UseGuards } from '@nestjs/common';
import { WalletService } from './wallet.service';
import { CreateWalletDto } from './dto/create-wallet.dto';
import { UpdateWalletDto } from './dto/update-wallet.dto';
import { AuthGuard } from '../auth/auth.guard';
import { User } from '../auth/user.decorator';

@Controller('wallets')
export class WalletController {
    constructor(private readonly walletService: WalletService) { }

    // Создание нового кошелька
    @UseGuards(AuthGuard)
    @Post()
    async create(@Body() createWalletDto: CreateWalletDto, @User() user: any) {
        try {
            console.log(user);
            createWalletDto.userId = user.sub;
            const wallet = await this.walletService.create(createWalletDto);
            return { data: wallet, error: '', success: true };
        } catch (error) {
            return { data: {}, error: error.message, success: false };
        }
    }

    // Получение кошельков по userId
    @UseGuards(AuthGuard)
    @Get('findManyWallets')
    async findAllByUserId(@User() user: any) {
        try {
            const wallets = await this.walletService.findAllByUserId(user.sub);
            return { data: wallets, error: '', success: true };
        }
        catch (error) {
            return { data: {}, error: error, success: false };
        }
    }

    // Получение кошелька по его ID
    @UseGuards(AuthGuard)
    @Get(':id')
    async findOne(@Param('id') id: string) {
        try {
            const wallet = this.walletService.findOneById(id);
            return { data: wallet, error: '', success: true };
        }
        catch (error) {
            return { data: {}, error: error, success: false };
        }
    }

    // Обновление данных кошелька
    @UseGuards(AuthGuard)
    @Put(':id')
    async update(
        @Param('id') id: string,
        @Body() updateWalletDto: UpdateWalletDto,
    ) {
        try {
            const wallet = this.walletService.update(id, updateWalletDto);
            return { data: wallet, error: '', success: true };
        }
        catch (error) {
            return { data: {}, error: error, success: false };
        }
    }

    // Удаление кошелька
    @UseGuards(AuthGuard)
    @Delete(':id')
    async remove(@Param('id') id: string): Promise<any> {
        try {
            const wallet = this.walletService.remove(id);
            return { data: wallet, error: '', success: true };
        }
        catch (error) {
            return { data: {}, error: error, success: false };
        }
    }
}
