import { Schema } from 'mongoose';

export const CategorySchema = new Schema({
  userId: { type: Schema.Types.ObjectId, ref: 'User', required: true },
  name: { type: String, required: true },
  type: { type: String, required: true, enum: ['income', 'expense'] },
  icon: { type: String },
  // color: { type: String },
  createdAt: { type: Date, default: Date.now },
  updatedAt: { type: Date, default: Date.now }
});


export interface Category extends Document {
  userId: string;
  name: string;
  type: string;
  icon: string;
  // color: string;
  createdAt: Date;
  updatedAt: Date;
}