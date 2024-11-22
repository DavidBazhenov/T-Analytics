import { IsString, IsEnum, IsNumber, IsNotEmpty, IsOptional } from 'class-validator';

export class CreateWalletDto {
    @IsString()
    @IsNotEmpty()
    name: string;

    @IsEnum(['cash', 'bank', 'electronic'])
    @IsNotEmpty()
    type: string;

    @IsNumber()
    balance: number;

    @IsString()
    @IsNotEmpty()
    currency: string;

    @IsOptional()
    userId?: string;
}
