# 📝 API Documentation Template

## 🎯 How to Provide API Information

When you provide API endpoints and responses, please use this format. This will make it easy for me to:
1. Generate proper models
2. Create repository methods
3. Handle serialization correctly
4. Add proper error handling

---

## 📋 Template Format

```markdown
## API: [Endpoint Name]

### Endpoint Details
- **Method**: GET/POST/PUT/DELETE
- **URL**: `/api/endpoint`
- **Authentication**: Required/Not Required
- **Description**: Brief description of what this endpoint does

### Request Body (if applicable)
```json
{
  "field1": "value1",
  "field2": 123,
  "field3": true,
  "field4": {
    "nested": "value"
  },
  "field5": ["item1", "item2"]
}
```

### Request Parameters (if applicable)
- `param1` (query): string, required - Description
- `param2` (query): int, optional - Description

### Success Response (200)
```json
{
  "success": true,
  "message": "Success message",
  "data": {
    // Your actual data structure here
  },
  "status_code": 200
}
```

### Error Responses
```json
// 400 Bad Request
{
  "success": false,
  "message": "Validation error",
  "errors": {
    "field1": ["Error message 1", "Error message 2"]
  },
  "status_code": 400
}

// 401 Unauthorized
{
  "success": false,
  "message": "Unauthorized",
  "status_code": 401
}

// 404 Not Found
{
  "success": false,
  "message": "Resource not found",
  "status_code": 404
}
```

### Notes
- Any special handling requirements
- Edge cases
- Business logic notes
```

---

## 📝 Example

```markdown
## API: Get Bookings

### Endpoint Details
- **Method**: GET
- **URL**: `/api/bookings`
- **Authentication**: Required
- **Description**: Get list of bookings for the authenticated user

### Request Parameters
- `status` (query): string, optional - Filter by status (confirmed, pending, cancelled)
- `page` (query): int, optional - Page number (default: 1)
- `limit` (query): int, optional - Items per page (default: 10)
- `from_date` (query): string, optional - Filter from date (YYYY-MM-DD)
- `to_date` (query): string, optional - Filter to date (YYYY-MM-DD)

### Success Response (200)
```json
{
  "success": true,
  "message": "Bookings retrieved successfully",
  "data": {
    "bookings": [
      {
        "id": "1",
        "booking_id": "26384624",
        "venue_name": "Elite Sports Arena",
        "location": "Los Angeles, CA",
        "rating": 4.8,
        "status": "confirmed",
        "coach": {
          "name": "Elijah Scott",
          "email": "elijahscott@gmail.com",
          "image_url": "https://example.com/image.jpg"
        },
        "players": [
          {
            "name": "Player 1",
            "image_url": "https://example.com/player1.jpg"
          }
        ],
        "schedule": {
          "court": "Court 1",
          "slots": 3,
          "date": "2025-04-24",
          "time": "08:30-10:30"
        },
        "reserved_by": "Members Sports Academy",
        "sport_type": "Basketball",
        "booking_as": "Owner",
        "coach_request_status": "accepted",
        "equipment_actions": [
          {
            "type": "purchase",
            "label": "Purchase"
          }
        ],
        "created_at": "2025-04-20T10:00:00Z",
        "updated_at": "2025-04-20T10:00:00Z"
      }
    ],
    "pagination": {
      "current_page": 1,
      "total_pages": 5,
      "total_items": 50,
      "items_per_page": 10
    }
  },
  "status_code": 200
}
```

### Error Responses
// 401 Unauthorized
{
  "success": false,
  "message": "Authentication required",
  "status_code": 401
}

// 422 Validation Error
{
  "success": false,
  "message": "Validation failed",
  "errors": {
    "from_date": ["Invalid date format"],
    "status": ["Invalid status value"]
  },
  "status_code": 422
}
```

---

## 🎯 Alternative Formats I Can Accept

### Format 1: Simple JSON Examples
Just provide the request and response JSON examples, and I'll infer the structure.

### Format 2: Swagger/OpenAPI
If you have Swagger/OpenAPI documentation, I can work with that.

### Format 3: Postman Collection
If you have a Postman collection, I can extract the information.

### Format 4: Structured List
Just provide a list like:
```
GET /api/bookings
- Query params: status, page, limit
- Response: { bookings: [...], pagination: {...} }
```

---

## ✅ What I'll Do With Your Information

1. **Create Models**: Generate Dart models with proper fromJson/toJson
2. **Create Repository Methods**: Add methods to appropriate repositories
3. **Update Endpoints**: Add endpoint definitions to ApiEndpoints
4. **Handle Errors**: Add proper error handling
5. **Add Documentation**: Document the implementation

---

## 🚀 Quick Start

Just paste your API information in the chat using any format above, and I'll:
- Generate the models
- Create the repository methods
- Update the endpoints
- Provide usage examples

**Example**: 
```
Hey, here's the bookings API:
GET /api/bookings?status=confirmed&page=1
Response: { "success": true, "data": { "bookings": [...] } }
```

I'll handle the rest! 🎉

