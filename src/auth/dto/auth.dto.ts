import { IsString, IsEmail, MinLength, MaxLength, IsNotEmpty } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class AuthDto {
    @ApiProperty({
        description: 'The full name of the user',
        example: 'John Doe',
        maxLength: 50,
    })
    @IsString()
    @IsNotEmpty({ message: 'Name is required' })
    @MaxLength(50, { message: 'Name must not exceed 50 characters' })
    name: string;

    @ApiProperty({
        description: 'The email address of the user',
        example: 'johndoe@example.com',
    })
    @IsEmail({}, { message: 'Invalid email format' })
    @IsNotEmpty({ message: 'Email is required' })
    email: string;

    @ApiProperty({
        description: 'The password for the user',
        example: 'password123',
        minLength: 6,
        maxLength: 20,
    })
    @IsString()
    @MinLength(6, { message: 'Password must be at least 6 characters' })
    @MaxLength(20, { message: 'Password must not exceed 20 characters' })
    password: string;
}
