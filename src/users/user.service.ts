import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { User } from './schemas/user.schema';
import { Injectable, NotFoundException } from '@nestjs/common';
import { UpdateUserDto } from './dto/user-update.dto';

@Injectable()
export class UserService {
  constructor(@InjectModel('User') private userModel: Model<User>) { }

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

  async updateUser(userId: string, updateUserDto: UpdateUserDto) {
    const user = await this.findById(userId);
    if (!user) {
      throw new NotFoundException('User not found');
    }

    Object.assign(user, updateUserDto);

    await user.save();
    return user;
  }
}
