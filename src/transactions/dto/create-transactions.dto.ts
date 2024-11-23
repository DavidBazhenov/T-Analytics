import { IsOptional, IsString, IsNumber, IsDateString, IsEnum } from 'class-validator';

export class CreateTransactionDto {
    @IsOptional()
    @IsString()
    userId: string;

    @IsString()
    category: { name: string; icon: string; color: string };

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
