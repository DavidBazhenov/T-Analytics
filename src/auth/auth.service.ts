import { Injectable, UnauthorizedException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import * as bcrypt from 'bcryptjs';
import { User } from '../users/schemas/user.schema';
import { JwtPayload } from './jwt-payload.interface';
import { JwtService } from '@nestjs/jwt';

@Injectable()
export class AuthService {
  constructor(
    @InjectModel('User') private readonly userModel: Model<User>, // Используем модель User через InjectModel
    private readonly jwtService: JwtService, // Используем JwtService
  ) { }

  // Регистрация пользователя
  async register(name: string, email: string, password: string): Promise<User> {
    const existingUser = await this.userModel.findOne({ email });
    if (existingUser) {
      throw new UnauthorizedException('Пользователь с таким email уже существует');
    }

    const salt = await bcrypt.genSalt();
    const passwordHash = await bcrypt.hash(password, salt);

    const newUser = new this.userModel({ name, email, passwordHash });
    return await newUser.save();
  }

  // Вход пользователя (проверка email и пароля)
  async login(email: string, password: string): Promise<{ accessToken: string }> {
    const user = await this.userModel.findOne({ email });

    if (!user) {
      throw new UnauthorizedException('Неверный email или пароль');
    }

    const isPasswordValid = await bcrypt.compare(password, user.passwordHash);
    if (!isPasswordValid) {
      throw new UnauthorizedException('Неверный email или пароль');
    }

    const payload: JwtPayload = { email: user.email, sub: user.id };

    // Генерация JWT токена с использованием JwtService
    const accessToken = this.jwtService.sign(payload, {
      secret: process.env.JWT_SECRET, // Секретный ключ для подписи
      expiresIn: '1h',
    });

    return { accessToken };
  }
}
