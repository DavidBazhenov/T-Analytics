import { IsOptional, IsString, IsEmail, Length } from 'class-validator';

export class CreateUserDto {
    @IsString()
    @Length(2, 50)
    name: string;
    @IsEmail()
    email: string;
    @IsString()
    @Length(2, 100)
    password: string;
    @IsOptional()
    @IsString()
    @Length(2, 100)
    phone?: string;
}
