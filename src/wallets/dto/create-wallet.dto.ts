import { IsString, IsEnum, IsNumber, IsNotEmpty } from 'class-validator';

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
}
