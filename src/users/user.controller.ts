import { Controller, Get, UseGuards, Req, Put, Body } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiBearerAuth } from '@nestjs/swagger';
import { UserService } from './user.service';
import { AuthGuard } from '../auth/auth.guard';
import { access } from 'fs';
import { UpdateUserDto } from './dto/user-update.dto';

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
        phone: user.phone,
      },
      error: '',
      success: true
    };
  }

  @Put('me')
  @UseGuards(AuthGuard)
  @ApiOperation({
    summary: 'Edit the current authenticated user data',
    description: 'Update the user data. Authorization header with Bearer Token is required.',
  })
  @ApiResponse({
    status: 200,
    description: 'Successfully updated the user data',
    schema: {
      example: {
        success: true,
        data: {
          id: '64d1f5c7f3b7c800168ad39b',
          name: 'Jane Doe',
          email: 'jane.doe@example.com',
          createdAt: '2024-11-20T08:20:34.567Z',
        },
        error: '',
      },
    },
  })
  @ApiResponse({
    status: 400,
    description: 'Bad Request - Invalid data',
    schema: {
      example: {
        success: false,
        data: {},
        error: 'Validation failed',
      },
    },
  })
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
  })
  async updateCurrentUser(@Req() request, @Body() updateUserDto: UpdateUserDto) {
    const userId = request.user.sub;

    const updatedUser = await this.userService.updateUser(userId, updateUserDto);
    return {
      data: {
        id: updatedUser.id,
        name: updatedUser.name,
        email: updatedUser.email,
        createdAt: updatedUser.createdAt,
        phone: updatedUser.phone
      },
      error: '',
      success: true,
    };
  }

}
