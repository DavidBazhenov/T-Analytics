import { Controller, Post, Body, HttpCode } from '@nestjs/common';
import { AuthService } from './auth.service';
import { AuthDto } from './dto/auth.dto';
import { ApiTags, ApiOperation, ApiResponse, ApiBody } from '@nestjs/swagger';
import { AuthPhoneDto } from './dto/auth-phone.dto';

@ApiTags('Authentication') // Группировка эндпоинтов в Swagger
@Controller('auth')
export class AuthController {
    constructor(private readonly authService: AuthService) { }

    @Post('register')
    @ApiOperation({ summary: 'Register a new user', parameters: [] })
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
    @HttpCode(200)
    async login(@Body() authDto: AuthDto) {
        return this.authService.login(authDto.email, authDto.password);
    }

    @Post('phone-login')
    @ApiOperation({ summary: 'Fake authorization via phone' })
    @ApiBody({ type: AuthPhoneDto })
    @ApiResponse({
        status: 201,
        description: 'User authorized via phone',
        schema: {
            example: {
                success: true,
                data: {
                    accessToken: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
                    user: {
                        id: 'abc123',
                        name: 'Fake User',
                        phone: '+1234567890',
                        email: 'fake@example.com',
                    },
                },
                error: '',
            },
        },
    })
    async phoneLogin(@Body() authPhoneDto: AuthPhoneDto) {
        return this.authService.phoneLogin(authPhoneDto.phone);
    }

}
``
