import { IsString, IsEnum, IsNumber, IsOptional } from 'class-validator';

export class UpdateWalletDto {
    @IsString()
    @IsOptional()
    name?: string;

    @IsEnum(['cash', 'bank', 'electronic'])
    @IsOptional()
    type?: string;

    @IsNumber()
    @IsOptional()
    balance?: number;

    @IsString()
    @IsOptional()
    currency?: string;
}
