import { Injectable, UnauthorizedException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import * as bcrypt from 'bcryptjs';
import { User } from '../users/schemas/user.schema';
import { JwtPayload } from './jwt-payload.interface';
import { JwtService } from '@nestjs/jwt';
import { error } from 'console';
import { Wallet } from '../wallets/schemas/wallet.schema'; // Импорт модели Wallet
@Injectable()
export class AuthService {
  constructor(
    @InjectModel('User') private readonly userModel: Model<User>, // Модель User
    private readonly jwtService: JwtService,
  ) { }



  // Регистрация пользователя
  async register(name: string, email: string, password: string) {
    const existingUser = await this.userModel.findOne({ email });
    if (existingUser) {
      return { data: {}, error: 'User already exists', success: false };
    }

    const salt = await bcrypt.genSalt();
    const passwordHash = await bcrypt.hash(password, salt);

    // Создание нового пользователя
    const newUser = new this.userModel({ name, email, passwordHash });
    const savedUser = await newUser.save();

    // Генерация JWT токена после регистрации пользователя
    const payload = { email: savedUser.email, sub: savedUser._id };
    const accessToken = this.jwtService.sign(payload, {
      secret: process.env.JWT_SECRET, // Секретный ключ
      expiresIn: '12h',
    });

    return { data: { accessToken }, error: '', success: true };
  }

  // Вход пользователя (проверка email и пароля)
  async login(email: string, password: string): Promise<{ data: {}, error: string, success: boolean }> {
    const user = await this.userModel.findOne({ email });

    if (!user) {
      return { data: {}, error: 'Пользователь не существует', success: false };
    }

    const isPasswordValid = await bcrypt.compare(password, user.passwordHash);
    if (!isPasswordValid) {
      return { data: {}, error: 'Неверный пароль', success: false };
    }

    const payload: JwtPayload = { email: user.email, sub: user.id };

    const accessToken = this.jwtService.sign(payload, {
      secret: process.env.JWT_SECRET,
      expiresIn: '12h',
    });

    return { data: { accessToken: accessToken }, error: '', success: true };
  }

  async phoneLogin(phone: string): Promise<{ data: any, error: string, success: boolean }> {
    let user = await this.userModel.findOne({ phone });

    if (!user) {
      user = new this.userModel({
        name: 'Fake User', // Дефолтное имя
        email: `${phone}@fake.com`, // Генерируем фейковый email
        phone,
        isFake: true, // Устанавливаем флаг фейкового пользователя
        passwordHash: await bcrypt.hash('defaultPassword', 10),
      });

      await user.save();

    }

    // Генерируем JWT-токен для пользователя
    const payload = { sub: user.id, phone: user.phone };
    const accessToken = this.jwtService.sign(payload, {
      secret: process.env.JWT_SECRET,
      expiresIn: '12h',
    });

    return {
      data: {
        accessToken: accessToken,
      },
      error: '',
      success: true,
    };
  }
}