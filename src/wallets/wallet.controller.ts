import { Controller, Post, Get, Param, Body, Put, Delete, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiBody, ApiParam, ApiBearerAuth } from '@nestjs/swagger';
import { WalletService } from './wallet.service';
import { CreateWalletDto } from './dto/create-wallet.dto';
import { UpdateWalletDto } from './dto/update-wallet.dto';
import { AuthGuard } from '../auth/auth.guard';
import { User } from '../auth/user.decorator';

@ApiTags('Wallets') // Группировка эндпоинтов в секцию "Wallets" в Swagger
@Controller('wallets')
export class WalletController {
    constructor(private readonly walletService: WalletService) { }

    // Создание нового кошелька
    @UseGuards(AuthGuard)
    @Post()
    @ApiBearerAuth()
    @ApiOperation({
        summary: 'Create a new wallet',
        description: 'Use Bearer Token in Authorization header to get this response',
    })
    @ApiBody({ type: CreateWalletDto, description: 'Data to create a new wallet' })
    @ApiResponse({
        status: 201,
        description: 'Wallet created successfully',
        schema: {
            example: {
                success: true,
                data: {
                    id: '64d1f5c7f3b7c800168ad39b',
                    userId: '64d1f5c7f3b7c800168ad38a',
                    balance: 1000,
                    currency: 'USD',
                    createdAt: '2024-11-20T08:20:34.567Z',
                    updatedAt: '2024-11-20T08:20:34.567Z',
                },
                error: '',
            },
        },
    })
    @ApiResponse({
        status: 400,
        description: 'Bad request or validation error',
        schema: {
            example: {
                success: false,
                data: {},
                error: 'Invalid wallet data',
            },
        },
    })
    async create(@Body() createWalletDto: CreateWalletDto, @User() user: any) {
        try {
            createWalletDto.userId = user.sub;
            const wallet = await this.walletService.create(createWalletDto);
            return { data: wallet, error: '', success: true };
        } catch (error) {
            return { data: {}, error: error.message, success: false };
        }
    }

    // Получение всех кошельков пользователя по userId
    @UseGuards(AuthGuard)
    @Get('findManyWallets')
    @ApiBearerAuth()
    @ApiOperation({
        summary: 'Get all wallets for the user',
        description: 'Use Bearer Token in Authorization header to get this response',
    })
    @ApiResponse({
        status: 200,
        description: 'List of wallets retrieved successfully',
        schema: {
            example: {
                success: true,
                data: [
                    {
                        id: '64d1f5c7f3b7c800168ad39b',
                        userId: '64d1f5c7f3b7c800168ad38a',
                        balance: 1000,
                        currency: 'USD',
                    },
                    {
                        id: '64d1f5c7f3b7c800168ad39c',
                        userId: '64d1f5c7f3b7c800168ad38a',
                        balance: 500,
                        currency: 'EUR',
                    },
                ],
                error: '',
            },
        },
    })
    async findAllByUserId(@User() user: any) {
        try {
            const wallets = await this.walletService.findAllByUserId(user.sub);
            return { data: wallets, error: '', success: true };
        } catch (error) {
            return { data: {}, error: error.message, success: false };
        }
    }

    // Получение кошелька по его ID
    @UseGuards(AuthGuard)
    @Get(':id')
    @ApiBearerAuth()
    @ApiOperation({
        summary: 'Get wallet by ID',
        description: 'Use Bearer Token in Authorization header to get this response',
    })
    @ApiParam({ name: 'id', description: 'Wallet ID' })
    @ApiResponse({
        status: 200,
        description: 'Wallet retrieved successfully',
        schema: {
            example: {
                success: true,
                data: {
                    id: '64d1f5c7f3b7c800168ad39b',
                    userId: '64d1f5c7f3b7c800168ad38a',
                    balance: 1000,
                    currency: 'USD',
                    createdAt: '2024-11-20T08:20:34.567Z',
                    updatedAt: '2024-11-20T08:20:34.567Z',
                },
                error: '',
            },
        },
    })
    @ApiResponse({
        status: 404,
        description: 'Wallet not found',
        schema: {
            example: {
                success: false,
                data: {},
                error: 'Wallet not found',
            },
        },
    })
    async findOne(@Param('id') id: string) {
        try {
            const wallet = await this.walletService.findOneById(id);
            return { data: wallet, error: '', success: true };
        } catch (error) {
            return { data: {}, error: error.message, success: false };
        }
    }

    // Обновление данных кошелька
    @UseGuards(AuthGuard)
    @Put(':id')
    @ApiBearerAuth()
    @ApiOperation({
        summary: 'Update wallet by ID',
        description: 'Use Bearer Token in Authorization header to get this response',
    })
    @ApiParam({ name: 'id', description: 'Wallet ID' })
    @ApiBody({ type: UpdateWalletDto, description: 'Data to update the wallet' })
    @ApiResponse({
        status: 200,
        description: 'Wallet updated successfully',
        schema: {
            example: {
                success: true,
                data: {
                    id: '64d1f5c7f3b7c800168ad39b',
                    userId: '64d1f5c7f3b7c800168ad38a',
                    balance: 1200,
                    currency: 'USD',
                    updatedAt: '2024-11-20T08:30:34.567Z',
                },
                error: '',
            },
        },
    })
    async update(
        @Param('id') id: string,
        @Body() updateWalletDto: UpdateWalletDto,
    ) {
        try {
            const wallet = await this.walletService.update(id, updateWalletDto);
            return { data: wallet, error: '', success: true };
        } catch (error) {
            return { data: {}, error: error.message, success: false };
        }
    }

    // Удаление кошелька
    @UseGuards(AuthGuard)
    @Delete(':id')
    @ApiBearerAuth()
    @ApiOperation({
        summary: 'Delete wallet by ID',
        description: 'Use Bearer Token in Authorization header to get this response',
    })
    @ApiParam({ name: 'id', description: 'Wallet ID' })
    @ApiResponse({
        status: 200,
        description: 'Wallet deleted successfully',
        schema: {
            example: {
                success: true,
                data: null,
                error: '',
            },
        },
    })
    @ApiResponse({
        status: 404,
        description: 'Wallet not found',
        schema: {
            example: {
                success: false,
                data: {},
                error: 'Wallet not found',
            },
        },
    })
    async remove(@Param('id') id: string): Promise<any> {
        try {
            const wallet = await this.walletService.remove(id);
            return { data: wallet, error: '', success: true };
        } catch (error) {
            return { data: {}, error: error.message, success: false };
        }
    }
}
