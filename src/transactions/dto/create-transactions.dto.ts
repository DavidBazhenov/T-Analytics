import { IsOptional, IsString, IsNumber, IsDateString, IsEnum } from 'class-validator';

export class CreateTransactionDto {
    @IsString()
    userId: string;

    @IsString()
    categoryId: string;

    @IsOptional()
    @IsString()
    walletFromId?: string;

    @IsOptional()
    @IsString()
    walletToId?: string;

    @IsNumber()
    amount: number;

    @IsEnum(['income', 'expense', 'transfer'])
    type: 'income' | 'expense' | 'transfer';

    @IsOptional()
    @IsDateString()
    date?: string;

    @IsOptional()
    @IsString()
    description?: string;
}
