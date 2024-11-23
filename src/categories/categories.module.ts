import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { CategorySchema } from './schemas/category.schema';
import { CategoryService } from './categories.service';
import { CategoryController } from './category.controller';
import { AuthModule } from '../auth/auth.module';
import { JwtModule } from '@nestjs/jwt';

@Module({
  imports: [
    AuthModule,
    MongooseModule.forFeature([{ name: 'Category', schema: CategorySchema }]),
    JwtModule.register({ secret: process.env.JWT_SECRET || 'secret', signOptions: { expiresIn: '12h' } }),
  ],
  controllers: [CategoryController],
  providers: [CategoryService],
})
export class CategoryModule { }
