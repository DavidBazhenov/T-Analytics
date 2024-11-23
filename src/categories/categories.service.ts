import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Category } from './schemas/category.schema';
import { CreateCategoryDto } from './dto/create-category.dto';

@Injectable()
export class CategoryService {
    constructor(
        @InjectModel('Category') private readonly categoryModel: Model<Category>,
    ) { }

    // Создание новой категории
    async createCategory(userId: string, createCategoryDto: CreateCategoryDto): Promise<Category> {
        const category = new this.categoryModel({ ...createCategoryDto, userId });
        return category.save();
    }

    // Создание категорий по умолчанию для нового пользователя
    async createDefaultCategories(userId: string): Promise<void> {
        const defaultCategories = [
            { name: 'salary', type: 'income', icon: '💰', color: '#4CAF50' },
            { name: 'advance', type: 'income', icon: '💰', color: '#4CAF50' },
            { name: 'food', type: 'expense', icon: '🛒', color: '#FF5722' },
            { name: 'transport', type: 'expense', icon: '🚗', color: '#03A9F4' },
            { name: 'entertainment', type: 'expense', icon: '🎮', color: '#FFC107' },
        ];

        // Получаем текущие категории пользователя
        const userCategories = await this.getUserCategories(userId);

        // Ищем дефолтные категории, которых еще нет у пользователя
        const categoriesToCreate = defaultCategories.filter(
            (defaultCategory) =>
                !userCategories.some(
                    (userCategory) =>
                        userCategory.name === defaultCategory.name &&
                        userCategory.type === defaultCategory.type,
                ),
        );

        // Добавляем только недостающие дефолтные категории
        if (categoriesToCreate.length > 0) {
            const categories = categoriesToCreate.map((category) => ({
                ...category,
                userId,
            }));
            await this.categoryModel.insertMany(categories);
        }
    }


    // Получение всех категорий пользователя
    async getUserCategories(userId: string): Promise<Category[]> {
        return this.categoryModel.find({ userId }).exec();
    }

    // Удаление категории
    async deleteCategory(userId: string, categoryId: string): Promise<void> {
        const result = await this.categoryModel.deleteOne({ _id: categoryId, userId });
        if (result.deletedCount === 0) {
            throw new NotFoundException('Category not found');
        }
    }
}
