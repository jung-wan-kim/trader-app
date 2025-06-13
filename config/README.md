# Trader App Configuration Guide

## API Keys Setup

### Finnhub API Key

1. Get your free API key from [Finnhub](https://finnhub.io/)
2. Create environment configuration files:

#### Development Configuration
Create `config/development.env`:
```
FINNHUB_API_KEY=your_finnhub_api_key_here
```

#### Production Configuration  
Create `config/production.env`:
```
FINNHUB_API_KEY=your_production_finnhub_api_key_here
```

#### Staging Configuration
Create `config/staging.env`:
```
FINNHUB_API_KEY=your_staging_finnhub_api_key_here
```

### Using API Keys in Code

The API keys are loaded through the `EnvConfig` class in `lib/config/env_config.dart`.

Example usage:
```dart
final apiKey = EnvConfig.finnhubApiKey;
```

### Security Notes

- Never commit `.env` files to version control
- Add `*.env` to your `.gitignore` file
- Use different API keys for different environments
- Consider using secret management services for production