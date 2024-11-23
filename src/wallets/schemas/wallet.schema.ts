import { Schema, Document } from 'mongoose';

export const WalletSchema = new Schema({
  userId: { type: Schema.Types.ObjectId, ref: 'User', required: true },
  name: { type: String, required: true },
  type: { type: String, required: true, enum: ['cash', 'bank', 'electronic'] },
  balance: { type: Number, required: true, default: 0 },
  currency: { type: String, required: true },
  createdAt: { type: Date, default: Date.now },
  updatedAt: { type: Date, default: Date.now },
  color: { type: String, required: true },
});

export interface Wallet extends Document {
  userId: string;
  name: string;
  type: string;
  balance: number;
  currency: string;
  createdAt: Date;
  updatedAt: Date;
}
