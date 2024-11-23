import { Controller, Get, UseGuards, Req } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse } from '@nestjs/swagger';
import { UserService } from './user.service';
import { AuthGuard } from '../auth/auth.guard';
import { access } from 'fs';

@ApiTags('Users') // Группировка эндпоинтов в секцию "Users" в Swagger
@Controller('users')
export class UserController {
  constructor(private readonly userService: UserService) { }

  @Get('me')
  @UseGuards(AuthGuard)
  @ApiOperation({
    summary: 'Get the current authenticated user',
    description: 'Use Bearer Token in Authorization header to get this response',
  }) // Описание операции
  @ApiResponse({
    status: 200,
    description: 'Successfully retrieved the current user data',
    schema: {
      example: {
        success: true,
        data: {
          id: '64d1f5c7f3b7c800168ad39b',
          name: 'John Doe',
          email: 'john.doe@example.com',
          createdAt: '2024-11-20T08:20:34.567Z',
        },
        error: '',
      },
    },
  }) // Пример успешного ответа
  @ApiResponse({
    status: 401,
    description: 'Unauthorized - User is not authenticated',
    schema: {
      example: {
        success: false,
        data: {},
        error: 'Unauthorized',
      },
    },
  }) // Пример ошибки 401
  async getCurrentUser(@Req() request) {
    const userId = request.user.sub;

    const user = await this.userService.findById(userId);
    return {
      data: {
        id: user.id,
        name: user.name,
        email: user.email,
        createdAt: user.createdAt,
      },
      error: '',
      success: true
    };
  }

}
