import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { TransactionService } from './transactions.services';
import { TransactionController } from './transactions.controller';
import { TransactionSchema } from './schemas/transaction.schema';
import { WalletSchema } from '../wallets/schemas/wallet.schema';
import { AuthModule } from '../auth/auth.module';
import { JwtModule } from '@nestjs/jwt';
import { UserModule } from '../users/user.module';

@Module({
    imports: [
        UserModule,
        AuthModule,
        MongooseModule.forFeature([
            { name: 'Transaction', schema: TransactionSchema },
            { name: 'Wallet', schema: WalletSchema },
        ]),
        JwtModule.register({ secret: process.env.JWT_SECRET || 'secret', signOptions: { expiresIn: '12h' } }),
    ],
    controllers: [TransactionController],
    providers: [TransactionService],
})
export class TransactionsModule { }
