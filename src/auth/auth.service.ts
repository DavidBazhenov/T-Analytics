import { Injectable, UnauthorizedException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import * as bcrypt from 'bcryptjs';
import { User } from '../users/schemas/user.schema';
import { JwtPayload } from './jwt-payload.interface';
import { JwtService } from '@nestjs/jwt';
import { error } from 'console';

@Injectable()
export class AuthService {
  constructor(
    @InjectModel('User') private readonly userModel: Model<User>,
    private readonly jwtService: JwtService, // Используем JwtService
  ) { }

  // Регистрация пользователя
  async register(name: string, email: string, password: string) {
    const existingUser = await this.userModel.findOne({ email });
    if (existingUser) {
      return { data: {}, error: 'error while creating user', success: false };
    }

    const salt = await bcrypt.genSalt();
    const passwordHash = await bcrypt.hash(password, salt);

    const newUser = new this.userModel({ name, email, passwordHash });
    return { data: await newUser.save(), error: '', success: true };
  }

  // Вход пользователя (проверка email и пароля)
  async login(email: string, password: string): Promise<{ data: {}, error: string, success: boolean }> {
    const user = await this.userModel.findOne({ email });

    if (!user) {
      return { data: {}, error: 'Неверный email или пароль', success: false };
    }

    const isPasswordValid = await bcrypt.compare(password, user.passwordHash);
    if (!isPasswordValid) {
      return { data: {}, error: 'Неверный email или пароль', success: false };
    }

    const payload: JwtPayload = { email: user.email, sub: user.id };

    const accessToken = this.jwtService.sign(payload, {
      secret: process.env.JWT_SECRET,
      expiresIn: '1h',
    });

    return { data: { accessToken: accessToken }, error: '', success: true };
  }
}
