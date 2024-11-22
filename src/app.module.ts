import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { UserModule } from './users/user.module';
import { AuthModule } from './auth/auth.module';

@Module({
  imports: [
    MongooseModule.forRoot('mongodb://localhost:27017/expense-tracker'), // Подключение к MongoDB
    UserModule, // Импортируем модуль пользователей
    AuthModule, // Импортируем модуль аутентификации
  ],
})
export class AppModule {}
