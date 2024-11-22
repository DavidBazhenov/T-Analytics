import { Schema } from 'mongoose';

export const TransactionSchema = new Schema({
  userId: { type: Schema.Types.ObjectId, ref: 'User', required: true },
  categoryId: { type: Schema.Types.ObjectId, ref: 'Category', required: true },
  walletFromId: { type: Schema.Types.ObjectId, ref: 'Wallet', default: null },
  walletToId: { type: Schema.Types.ObjectId, ref: 'Wallet', default: null },
  amount: { type: Number, required: true },
  type: { type: String, required: true, enum: ['income', 'expense', 'transfer'] },
  date: { type: Date, default: Date.now },
  description: { type: String },
  createdAt: { type: Date, default: Date.now },
  updatedAt: { type: Date, default: Date.now }
});
