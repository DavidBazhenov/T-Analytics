import { Injectable } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor() {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(), // Извлечение токена из заголовка Authorization
      ignoreExpiration: false, // Не игнорировать срок действия токена
      secretOrKey: process.env.JWT_SECRET || 'secret', // Секрет для проверки токена
    });
  }

  async validate(payload: any) {
    // Возвращаем данные пользователя из токена (доступны через request.user)
    return { userId: payload.sub, email: payload.email };
  }
}
