import { Controller, Post, Body, Get, Param, Delete, UseGuards } from '@nestjs/common';
import { CategoryService } from './categories.service';
import { CreateCategoryDto } from './dto/create-category.dto';
import { AuthGuard } from '../auth/auth.guard';
import { User } from '../auth/user.decorator';

@Controller('categories')
@UseGuards(AuthGuard)
export class CategoryController {
    constructor(private readonly categoryService: CategoryService) { }

    // Добавление новой категории
    @Post()
    async createCategory(@Body() createCategoryDto: CreateCategoryDto, @User() user: any) {
        try {
            createCategoryDto.userId = user.sub;
            const category = await this.categoryService.createCategory(user.sub, createCategoryDto);
            return { data: category, error: '', success: true };
        }
        catch (error) {
            return { data: {}, error: error, success: false };
        }
    }

    // Создание категорий по умолчанию
    @Post('default')
    async createDefaultCategories(@User() user: any) {
        try {
            const category = await this.categoryService.createDefaultCategories(user.sub);
            return { data: category, error: '', success: true };
        }
        catch (error) {
            return { data: {}, error: error, success: false };
        }
    }

    // Получение всех категорий пользователя
    @Get()
    async getUserCategories(@User() user: any) {
        try {
            await this.categoryService.createDefaultCategories(user.sub);
            const category = await this.categoryService.getUserCategories(user.sub);
            return { data: category, error: '', success: true };
        }
        catch (error) {
            return { data: {}, error: error, success: false };
        }
    }

    // Удаление категории
    @Delete(':id')
    async deleteCategory(@Param('id') categoryId: string, @User() user: any) {
        try {
            const category = await this.categoryService.deleteCategory(user.sub, categoryId);
            return { data: category, error: '', success: true };
        }
        catch (error) {
            return { data: {}, error: error, success: false };
        }
    }
}
