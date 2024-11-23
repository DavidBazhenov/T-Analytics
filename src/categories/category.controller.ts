import { Controller, Post, Body, Get, Param, Delete, UseGuards, HttpCode } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBody, ApiResponse, ApiBearerAuth } from '@nestjs/swagger';
import { CategoryService } from './categories.service';
import { CreateCategoryDto } from './dto/create-category.dto';
import { AuthGuard } from '../auth/auth.guard';
import { User } from '../auth/user.decorator';

@ApiTags('Categories') // Группировка эндпоинтов
@Controller('categories')
@UseGuards(AuthGuard)
export class CategoryController {
    constructor(private readonly categoryService: CategoryService) { }

    // Добавление новой категории
    @Post()
    @ApiBearerAuth()
    @ApiOperation({
        summary: 'Create a new category for the user',
        description: 'Use Bearer Token in Authorization header to get this response',
    })
    @ApiBody({
        type: CreateCategoryDto,
        description: 'Data to create a new category',
    })
    @ApiResponse({
        status: 201,
        description: 'Category created successfully',
        schema: {
            example: {
                success: true,
                data: {
                    id: '64d1f5c7f3b7c800168ad39b',
                    userId: '64d1f5c7f3b7c800168ad38a',
                    name: 'Groceries',
                    type: 'expense',
                    icon: 'cart',
                    color: '#ffcc00',
                    createdAt: '2024-11-20T08:20:34.567Z',
                    updatedAt: '2024-11-20T08:20:34.567Z',
                },
                error: '',
            },
        },
    })
    @ApiResponse({
        status: 400,
        description: 'Validation error',
        schema: {
            example: {
                success: false,
                data: {},
                error: 'Name is required',
            },
        },
    })
    async createCategory(@Body() createCategoryDto: CreateCategoryDto, @User() user: any) {
        try {
            createCategoryDto.userId = user.sub;
            const category = await this.categoryService.createCategory(user.sub, createCategoryDto);
            return { data: category, error: '', success: true };
        } catch (error) {
            return { data: {}, error: error.message, success: false };
        }
    }

    // Создание категорий по умолчанию
    @Post('default')
    @ApiBearerAuth()
    @ApiOperation({
        summary: 'Create default categories for the user',
        description: 'Use Bearer Token in Authorization header to get this response',
    })
    @ApiResponse({
        status: 201,
        description: 'Default categories created successfully',
        schema: {
            example: {
                success: true,
                data: [
                    {
                        id: '64d1f5c7f3b7c800168ad39c',
                        userId: '64d1f5c7f3b7c800168ad38a',
                        name: 'Salary',
                        type: 'income',
                        icon: 'money',
                        color: '#00cc66',
                    },
                ],
                error: '',
            },
        },
    })
    async createDefaultCategories(@User() user: any) {
        try {
            const category = await this.categoryService.createDefaultCategories(user.sub);
            return { data: category, error: '', success: true };
        } catch (error) {
            return { data: {}, error: error.message, success: false };
        }
    }

    // Получение всех категорий пользователя
    @Get()
    @ApiBearerAuth()
    @ApiOperation({
        summary: 'Get all categories for the user',
        description: 'Use Bearer Token in Authorization header to get this response',
    })
    @ApiResponse({
        status: 200,
        description: 'User categories retrieved successfully',
        schema: {
            example: {
                success: true,
                data: [
                    {
                        id: '64d1f5c7f3b7c800168ad39b',
                        userId: '64d1f5c7f3b7c800168ad38a',
                        name: 'Groceries',
                        type: 'expense',
                        icon: 'cart',
                        color: '#ffcc00',
                    },
                ],
                error: '',
            },
        },
    })
    @HttpCode(200)
    async getUserCategories(@User() user: any) {
        try {
            await this.categoryService.createDefaultCategories(user.sub);
            const category = await this.categoryService.getUserCategories(user.sub);
            return { data: category, error: '', success: true };
        } catch (error) {
            return { data: {}, error: error.message, success: false };
        }
    }

    // Удаление категории
    @Delete(':id')
    @ApiBearerAuth()
    @ApiOperation({
        summary: 'Delete a category by its ID',
        description: 'Use Bearer Token in Authorization header to get this response',
    })
    @ApiResponse({
        status: 200,
        description: 'Category deleted successfully',
        schema: {
            example: {
                success: true,
                data: null,
                error: '',
            },
        },
    })
    @ApiResponse({
        status: 404,
        description: 'Category not found',
        schema: {
            example: {
                success: false,
                data: {},
                error: 'Category not found',
            },
        },
    })
    async deleteCategory(@Param('id') categoryId: string, @User() user: any) {
        try {
            const category = await this.categoryService.deleteCategory(user.sub, categoryId);
            return { data: category, error: '', success: true };
        } catch (error) {
            return { data: {}, error: error.message, success: false };
        }
    }
}
