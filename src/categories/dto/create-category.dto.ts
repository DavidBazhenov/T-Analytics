import { IsString, IsNotEmpty, IsOptional, IsEnum } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class CreateCategoryDto {
    @ApiProperty({ description: 'The name of the category', example: 'Groceries' })
    @IsString()
    @IsNotEmpty()
    name: string;

    @ApiProperty({ description: 'The type of the category (income/expense)', example: 'expense' })
    @IsString()
    @IsNotEmpty()
    @IsEnum(['income', 'expense'])
    type: string;

    @ApiProperty({ description: 'The icon of the category', example: '🛒' })
    @IsString()
    @IsOptional()
    icon?: string;

    @ApiProperty({ description: 'The color of the category', example: '#FF5722' })
    @IsString()
    @IsOptional()
    color?: string;

    @IsOptional()
    userId?: string;
}
