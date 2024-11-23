import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { WalletSchema } from './schemas/wallet.schema';
import { WalletService } from './wallet.service';
import { WalletController } from './wallet.controller';
import { UserModule } from '../users/user.module';
import { AuthModule } from '../auth/auth.module';
import { JwtModule } from '@nestjs/jwt';

@Module({
  imports: [
    UserModule,
    AuthModule,
    MongooseModule.forFeature([{ name: 'Wallet', schema: WalletSchema }]),
    JwtModule.register({ secret: process.env.JWT_SECRET || 'secret', signOptions: { expiresIn: '12h' } }),
  ],
  controllers: [WalletController],
  providers: [WalletService],
})
export class WalletModule { }
