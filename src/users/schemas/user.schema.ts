import { Schema, Document } from 'mongoose';

export const UserSchema = new Schema({
  name: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  phone: { type: String, unique: true, sparse: true },
  passwordHash: { type: String, required: true },
  isFake: { type: Boolean, default: false },
  createdAt: { type: Date, default: Date.now },
  updatedAt: { type: Date, default: Date.now },
  settings: {
    currency: { type: String, default: 'RUB' },
    language: { type: String, default: 'ru' }
  },
});

export interface User extends Document {
  id: string;
  name: string;
  email: string;
  phone?: string;
  isFake?: boolean;
  passwordHash: string;
  createdAt: Date,
  updatedAt: Date,
  settings: {
    currency: string;
    language: string;
  };
}
