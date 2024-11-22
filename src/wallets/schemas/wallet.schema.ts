import { Schema, Document } from 'mongoose';
import { User } from '../../users/schemas/user.schema';

export const WalletSchema = new Schema({
  userId: { type: Schema.Types.ObjectId, ref: 'User', required: true },
  name: { type: String, required: true },
  type: { type: String, required: true, enum: ['cash', 'bank', 'electronic'] },
  balance: { type: Number, required: true, default: 0 },
  currency: { type: String, required: true },
  createdAt: { type: Date, default: Date.now },
  updatedAt: { type: Date, default: Date.now },
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
