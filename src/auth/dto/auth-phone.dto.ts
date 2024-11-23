import { ApiProperty } from '@nestjs/swagger';
import { IsPhoneNumber, IsString } from 'class-validator';

export class AuthPhoneDto {
    @ApiProperty({ example: '+1234567890', description: 'Phone number for fake authorization' })
    @IsPhoneNumber()
    @IsString()
    phone: string;
}
