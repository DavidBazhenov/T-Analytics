import { Controller, Get, Post, Body, UseGuards, Req } from '@nestjs/common';
import { UserService } from './user.service';
import { AuthGuard } from '../auth/auth.guard';

@Controller('users')
export class UserController {
  constructor(private readonly userService: UserService) {}

  // Публичный маршрут для создания пользователя
  @Post()
  async create(@Body() createUserDto: { name: string; email: string; passwordHash: string }) {
    return this.userService.create(createUserDto);
  }

  // Защищённый маршрут для получения данных текущего пользователя
  @Get('me')
  @UseGuards(AuthGuard) // Применяем AuthGuard
  async getCurrentUser(@Req() request) {
    const userId = request.user.sub; 
    console.log('--->', userId);
    
    const user = await this.userService.findById(userId);
    return {
      id: user.id,
      name: user.name,
      email: user.email,
      createdAt: user.createdAt,
    };
  }
}
