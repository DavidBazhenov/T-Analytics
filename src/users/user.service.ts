import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { User } from './schemas/user.schema';

@Injectable()
export class UserService {
  constructor(@InjectModel('User') private userModel: Model<User>) {}

  async create(createUserDto: { name: string; email: string; passwordHash: string }) {
    const createdUser = new this.userModel(createUserDto);
    return createdUser.save();
  }

  async findById(id: string): Promise<User> {
    return this.userModel.findById(id).exec();
  }

  async findAll() {
    return this.userModel.find().exec();
  }
}
