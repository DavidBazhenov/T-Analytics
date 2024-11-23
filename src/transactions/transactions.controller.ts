import { Controller, Post, Put, Delete, Body, Param, Query, Get, UseGuards } from '@nestjs/common';
import { TransactionService } from './transactions.services';
import { Transaction } from './schemas/transaction.schema';
import { ApiBody, ApiOperation, ApiParam, ApiQuery, ApiResponse } from '@nestjs/swagger';
import { CreateTransactionDto } from './dto/create-transactions.dto';
import { AuthGuard } from '../auth/auth.guard';
import { User } from '../auth/user.decorator';
@UseGuards(AuthGuard)
@Controller('transactions')
export class TransactionController {
    constructor(private readonly transactionService: TransactionService) { }


    @Post()
    @ApiOperation({ summary: 'Create a new transaction' })
    @ApiBody({
        description: 'Transaction details',
        type: CreateTransactionDto,
        examples: {
            example: {
                summary: 'Create an expense transaction',
                value: {
                    userId: '63f6a5e77c840f2c7bcf5e6e',
                    categoryId: '63f6a5e77c840f2c7bcf5e6f',
                    walletFromId: '63f6a5e77c840f2c7bcf5e70',
                    amount: 500,
                    type: 'expense',
                    date: '2024-11-01T10:00:00Z',
                    description: 'Dinner at a restaurant',
                },
            },
        },
    })
    @ApiResponse({
        status: 201,
        description: 'Transaction created successfully',
        schema: {
            example: {
                success: true,
                data: {
                    id: '63f6a5e77c840f2c7bcf5e71',
                    userId: '63f6a5e77c840f2c7bcf5e6e',
                    categoryId: '63f6a5e77c840f2c7bcf5e6f',
                    walletFromId: '63f6a5e77c840f2c7bcf5e70',
                    amount: 500,
                    type: 'expense',
                    date: '2024-11-01T10:00:00Z',
                    description: 'Dinner at a restaurant',
                },
                error: '',
            },
        },
    })
    @ApiResponse({
        status: 400,
        description: 'Invalid input data',
        schema: {
            example: {
                success: false,
                data: null,
                error: 'Validation failed: amount must be a positive number',
            },
        },
    })
    async createTransaction(@Body() data: Partial<Transaction>, @User() user: any) {
        return this.transactionService.createTransaction(user, data);
    }

    @Put(':id')
    @ApiOperation({ summary: 'Update an existing transaction' })
    @ApiParam({
        name: 'id',
        description: 'ID of the transaction to update',
        example: '63f6a5e77c840f2c7bcf5e71',
    })
    @ApiBody({
        description: 'Updated transaction details',
        type: CreateTransactionDto,
        examples: {
            example: {
                summary: 'Update a transaction',
                value: {
                    categoryId: '63f6a5e77c840f2c7bcf5e6f',
                    amount: 700,
                    description: 'Updated transaction description',
                },
            },
        },
    })
    @ApiResponse({
        status: 200,
        description: 'Transaction updated successfully',
        schema: {
            example: {
                success: true,
                data: {
                    id: '63f6a5e77c840f2c7bcf5e71',
                    categoryId: '63f6a5e77c840f2c7bcf5e6f',
                    amount: 700,
                    type: 'expense',
                    date: '2024-11-01T10:00:00Z',
                    description: 'Updated transaction description',
                },
                error: '',
            },
        },
    })
    @ApiResponse({
        status: 404,
        description: 'Transaction not found',
        schema: {
            example: {
                success: false,
                data: null,
                error: 'Transaction not found',
            },
        },
    })
    async updateTransaction(
        @Param('id') transactionId: string,
        @Body() data: Partial<Transaction>,
    ) {
        return this.transactionService.updateTransaction(transactionId, data);
    }

    @Delete(':id')
    @ApiOperation({ summary: 'Delete a transaction' })
    @ApiParam({
        name: 'id',
        description: 'ID of the transaction to delete',
        example: '63f6a5e77c840f2c7bcf5e71',
    })
    @ApiResponse({
        status: 200,
        description: 'Transaction deleted successfully',
        schema: {
            example: {
                success: true,
            },
        },
    })
    @ApiResponse({
        status: 404,
        description: 'Transaction not found',
        schema: {
            example: {
                success: false,
                error: 'Transaction not found',
            },
        },
    })
    async deleteTransaction(@Param('id') transactionId: string) {
        await this.transactionService.deleteTransaction(transactionId);
        return { success: true };
    }

    @Get()
    @ApiOperation({ summary: 'Get a list of transactions with optional filters' })
    @ApiQuery({
        name: 'startDate',
        required: false,
        description: 'Start date for filtering transactions (ISO 8601 format)',
        example: '2024-11-01T00:00:00Z',
    })
    @ApiQuery({
        name: 'endDate',
        required: false,
        description: 'End date for filtering transactions (ISO 8601 format)',
        example: '2024-11-10T23:59:59Z',
    })
    @ApiQuery({
        name: 'categoryId',
        required: false,
        description: 'Filter transactions by category ID',
        example: '63f6a5e77c840f2c7bcf5e6f',
    })
    @ApiResponse({
        status: 200,
        description: 'List of transactions retrieved successfully',
        schema: {
            example: {
                success: true,
                data: [
                    {
                        id: '63f6a5e77c840f2c7bcf5e71',
                        userId: '63f6a5e77c840f2c7bcf5e6e',
                        categoryId: '63f6a5e77c840f2c7bcf5e6f',
                        walletFromId: '63f6a5e77c840f2c7bcf5e70',
                        amount: 500,
                        type: 'expense',
                        date: '2024-11-01T10:00:00Z',
                        description: 'Dinner at a restaurant',
                    },
                ],
                error: '',
            },
        },
    })
    @ApiResponse({
        status: 400,
        description: 'Invalid date range',
        schema: {
            example: {
                success: false,
                data: null,
                error: 'End date must be after start date',
            },
        },
    })
    async getTransactions(@User() user: any,
        @Query('startDate') startDate?: string,
        @Query('endDate') endDate?: string,
        @Query('categoryId') categoryId?: string,
    ) {
        const filters = {
            startDate: startDate ? new Date(startDate) : null,
            endDate: endDate ? new Date(endDate) : null,
            categoryId: categoryId || null,
        };

        const transactions = await this.transactionService.getTransactions(user, filters);
        return {
            data: transactions,
            error: '',
            success: true,
        };
    }
}