import { ApiProperty } from '@nestjs/swagger';
import { IsString, IsEnum, IsNumber, IsNotEmpty, IsOptional } from 'class-validator';

export class CreateWalletDto {
    @ApiProperty({ description: 'The name of the wallet', example: 'My wallet' })
    @IsString()
    @IsNotEmpty()
    name: string;

    @ApiProperty({ description: 'The type of the wallet (cash/bank/electronic)', example: 'cash' })
    @IsEnum(['cash', 'bank', 'electronic'])
    @IsNotEmpty()
    type: string;

    @ApiProperty({ description: 'The balance of the wallet', example: '100' })
    @IsNumber()
    balance: number;

    @ApiProperty({ description: 'The currency of the wallet', example: 'RUB' })
    @IsString()
    @IsNotEmpty()
    currency: string;

    @IsOptional()
    userId?: string;
}
