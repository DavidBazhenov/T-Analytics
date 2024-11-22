import { Schema, Document } from 'mongoose';

export const UserSchema = new Schema({
  name: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  passwordHash: { type: String, required: true },
  createdAt: { type: Date, default: Date.now },
  updatedAt: { type: Date, default: Date.now },
  settings: {
    currency: { type: String, default: 'RUB' },
    language: { type: String, default: 'ru' }
  }
});

export interface User extends Document {
  id: string;
  name: string;
  email: string;
  passwordHash: string;
  createdAt: Date,
  updatedAt: Date
}