import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { UserModule } from './users/user.module';
import { AuthModule } from './auth/auth.module';
import { CategoryModule } from './categories/categories.module';
import { WalletModule } from './wallets/wallet.module';

@Module({
  imports: [
    MongooseModule.forRoot('mongodb://localhost:27017/expense-tracker'),
    UserModule,
    AuthModule,
    WalletModule,
    CategoryModule,

  ],
})
export class AppModule { }
