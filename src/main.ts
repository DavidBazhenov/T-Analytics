import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { setupSwagger } from './swagger.config';
import * as dotenv from 'dotenv';

dotenv.config();

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  app.enableCors({
    origin: 'https://tlytics.ru', // или '*', если разрешены все домены
  });

  setupSwagger(app);

  await app.listen(3000, '0.0.0.0');
}
bootstrap();
