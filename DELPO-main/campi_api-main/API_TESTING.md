# API Test Documentation

## Server Status
✅ Laravel server running on http://localhost:8000
✅ CORS enabled for cross-origin requests
✅ Database migrations completed
✅ Authentication working with Laravel Sanctum

## Public Endpoints (No Authentication Required)

### Authentication
- `POST /api/register` - User registration
- `POST /api/login` - User login

### Products & Categories
- `GET /api/products` - List all products (paginated)
- `GET /api/products/{id}` - Get product details
- `GET /api/categories` - List all categories
- `GET /api/categories/{id}` - Get category details

### Stores
- `GET /api/stores` - List all stores
- `GET /api/stores/{id}` - Get store details
- `GET /api/stores/{id}/products` - Get products from a specific store

## Protected Endpoints (Require Authentication Token)

### User Management
- `GET /api/user` - Get current user profile
- `POST /api/logout` - Logout current user
- `POST /api/refresh` - Refresh authentication token

### Cart Management
- `GET /api/cart` - Get user's cart
- `POST /api/cart/add` - Add item to cart
- `PUT /api/cart/update/{item}` - Update cart item
- `DELETE /api/cart/remove/{item}` - Remove item from cart
- `DELETE /api/cart/clear` - Clear entire cart

### Order Management
- `GET /api/orders` - Get user's orders
- `GET /api/orders/{id}` - Get order details
- `POST /api/orders/create-from-cart` - Create order from cart
- `PATCH /api/orders/{id}/cancel` - Cancel order

### Wishlist
- `GET /api/wishlist` - Get user's wishlist
- `POST /api/wishlist` - Add item to wishlist
- `DELETE /api/wishlist/{id}` - Remove item from wishlist

### Store Management (Store Owners)
- `POST /api/stores` - Create new store
- `PUT /api/stores/{id}` - Update store
- `GET /api/stores/statistics` - Get store statistics

### Product Management (Store Owners)
- `POST /api/products` - Create new product
- `PUT /api/products/{id}` - Update product
- `DELETE /api/products/{id}` - Delete product
- `POST /api/products/{id}/images` - Upload product images

## Authentication Headers
All protected endpoints require:
```
Authorization: Bearer {your_access_token}
Accept: application/json
Content-Type: application/json
```

## Example Usage

### Register a new user:
```bash
curl -X POST "http://localhost:8000/api/register" \
  -H "Accept: application/json" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Doe",
    "email": "john@example.com",
    "password": "password123",
    "password_confirmation": "password123",
    "role_type": "client"
  }'
```

### Login:
```bash
curl -X POST "http://localhost:8000/api/login" \
  -H "Accept: application/json" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "john@example.com",
    "password": "password123"
  }'
```

### Access protected endpoint:
```bash
curl -X GET "http://localhost:8000/api/user" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer {token_from_login_response}"
```

## Frontend Integration Notes

1. **Base URL**: `http://localhost:8000/api`
2. **CORS**: Enabled for all origins (configure for production)
3. **Authentication**: Use Bearer tokens from login/register responses
4. **Error Handling**: All responses include `success` boolean and appropriate HTTP status codes
5. **Pagination**: List endpoints return paginated data with metadata

Your backend is ready for frontend integration!
