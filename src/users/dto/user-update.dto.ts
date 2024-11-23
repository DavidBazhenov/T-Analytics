import { IsOptional, IsString, IsEmail, Length } from 'class-validator';

export class UpdateUserDto {
    @IsOptional()
    @IsString()
    @Length(2, 50)
    name?: string;

    @IsOptional()
    @IsEmail()
    email?: string;

    @IsOptional()
    @IsString()
    @Length(2, 100)
    password?: string;

    @IsOptional()
    @IsString()
    @Length(2, 100)
    phone?: string;
}
