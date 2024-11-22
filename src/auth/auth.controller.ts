import { Controller, Post, Body } from '@nestjs/common';
import { AuthService } from './auth.service';
import { AuthDto } from './dto/auth.dto';
import { ApiTags, ApiOperation, ApiResponse, ApiBody } from '@nestjs/swagger';

@ApiTags('Authentication') // Группировка эндпоинтов в Swagger
@Controller('auth')
export class AuthController {
    constructor(private readonly authService: AuthService) { }

    @Post('register')
    @ApiOperation({ summary: 'Register a new user' })
    @ApiBody({ type: AuthDto })
    @ApiResponse({
        status: 201,
        description: 'User registered successfully',
        schema: {
            example: {
                success: true,
                data: {
                    id: '60f7c56f8b8e3b001c8d5647',
                    name: 'John Doe',
                    email: 'johndoe@example.com',
                },
                error: '',
            },
        },
    })
    @ApiResponse({
        status: 400,
        description: 'Validation error or user already exists',
        schema: {
            example: {
                success: false,
                data: {},
                error: 'User already exists',
            },
        },
    })
    async register(@Body() authDto: AuthDto) {
        return this.authService.register(authDto.name, authDto.email, authDto.password);
    }

    @Post('login')
    @ApiOperation({ summary: 'Log in an existing user' })
    @ApiBody({ type: AuthDto })
    @ApiResponse({
        status: 200,
        description: 'User logged in successfully',
        schema: {
            example: {
                success: true,
                data: {
                    accessToken: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
                },
                error: '',
            },
        },
    })
    @ApiResponse({
        status: 401,
        description: 'Invalid credentials',
        schema: {
            example: {
                success: false,
                data: {},
                error: 'Invalid email or password',
            },
        },
    })
    async login(@Body() authDto: AuthDto) {
        return this.authService.login(authDto.email, authDto.password);
    }
}
``
