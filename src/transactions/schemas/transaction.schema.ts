import { Document, Schema, model } from 'mongoose';

export const TransactionSchema = new Schema({
  userId: { type: Schema.Types.ObjectId, ref: 'User', required: true },
  category: {
    name: { type: Schema.Types.String, required: true },
    icon: { type: Schema.Types.String, required: false },
    color: { type: Schema.Types.String, required: false }
  },
  walletFromId: { type: Schema.Types.ObjectId, ref: 'Wallet', required: true },
  walletToId: { type: Schema.Types.ObjectId, ref: 'Wallet', default: null },
  amount: { type: Number, required: true },
  type: { type: String, required: true, enum: ['income', 'expense', 'transfer'] },
  date: { type: Date, default: Date.now },
  description: { type: String },
  createdAt: { type: Date, default: Date.now },
  updatedAt: { type: Date, default: Date.now }
});

export interface Transaction extends Document {
  userId: string;
  category: {
    name: string;
    icon: string;
    color: string;
  };
  walletFromId: string;
  walletToId?: string;
  amount: number;
  type: 'income' | 'expense' | 'transfer';
  date: Date;
  description?: string;
  createdAt: Date;
  updatedAt: Date;
}