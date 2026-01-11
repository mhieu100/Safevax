# PayPal Payment Setup Guide

## Why PayPal Shows "Not Configured"

PayPal payment is currently disabled because the required configuration is missing or contains placeholder values. The system detects this and shows a helpful dialog instead of failing silently.

## Required Configuration Steps

### 1. Create PayPal Business Account

1. Go to [PayPal Developer](https://developer.paypal.com/)
2. Sign up for a Business account (if you don't have one)
3. Verify your account

### 2. Create REST API Application

1. Log into [PayPal Developer Dashboard](https://developer.paypal.com/dashboard/)
2. Go to "Apps & Credentials" section
3. Click "Create App"
4. Choose "Merchant" as app type
5. Fill in app details:
   - App Name: Your app name (e.g., "Vaccine Booking App")
   - App Type: Merchant
   - Sandbox Business Account: Select your sandbox account

### 3. Get API Credentials

After creating the app, you'll get:

- **Client ID**: Starts with "AZ..." (Sandbox) or "A..." (Production)
- **Client Secret**: Starts with "EP..." (Sandbox) or "E..." (Production)

### 4. Update Environment Files

#### For Development (.env.dev):

```env
# PayPal Configuration
PAYPAL_CLIENT_ID=AZ...your_actual_sandbox_client_id
PAYPAL_CLIENT_SECRET=EP...your_actual_sandbox_client_secret
PAYPAL_ENVIRONMENT=sandbox
PAYPAL_RETURN_URL=yourapp://paypal/success
PAYPAL_CANCEL_URL=yourapp://paypal/cancel
```

#### For Production (.env.prod):

```env
# PayPal Configuration
PAYPAL_CLIENT_ID=A...your_actual_production_client_id
PAYPAL_CLIENT_SECRET=E...your_actual_production_client_secret
PAYPAL_ENVIRONMENT=production
PAYPAL_RETURN_URL=yourapp://paypal/success
PAYPAL_CANCEL_URL=yourapp://paypal/cancel
```

### 5. Test the Configuration

1. Replace the placeholder values with real credentials
2. Restart the app
3. Try making a payment with PayPal
4. The "not configured" dialog should no longer appear

## PayPal Environments

### Sandbox (Testing)

- **Environment**: `sandbox`
- **Client ID**: Starts with "AZ..."
- **Client Secret**: Starts with "EP..."
- **URL**: `https://api.sandbox.paypal.com`
- **Checkout URL**: `https://www.sandbox.paypal.com`

### Production (Live)

- **Environment**: `production`
- **Client ID**: Starts with "A..."
- **Client Secret**: Starts with "E..."
- **URL**: `https://api.paypal.com`
- **Checkout URL**: `https://www.paypal.com`

## Troubleshooting

### Still showing "not configured"?

1. Check that credentials don't contain placeholder text
2. Verify credentials start with correct prefixes (AZ/EP for sandbox, A/E for production)
3. Ensure no extra spaces or special characters
4. Restart the app after updating .env files

### PayPal API errors?

1. Verify your PayPal account is verified
2. Check that you're using the correct environment credentials
3. Ensure your app has the right permissions

### Deep Link Issues?

The app uses custom URL schemes for PayPal return/cancel:

- Success: `yourapp://paypal/success`
- Cancel: `yourapp://paypal/cancel`

Make sure these are configured in your app's deep linking setup.

## Security Notes

- Never commit real PayPal credentials to version control
- Use different credentials for sandbox and production
- Regularly rotate your API credentials
- Monitor your PayPal account for suspicious activity

## Support

If you continue having issues:

1. Check the app logs for detailed error messages
2. Verify your PayPal account status
3. Contact PayPal developer support if needed
