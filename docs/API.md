# API Documentation
## Hancom MND LMS

---

## Overview

This document describes the API structure for the Hancom Ministry of National Defense Learning Management System. The current version is a frontend-only demo that uses localStorage for data persistence. This documentation outlines the future backend API structure.

**Current Status**: Frontend-only (Demo)  
**Future**: RESTful API with backend server

---

## Table of Contents

1. [Authentication](#authentication)
2. [Users](#users)
3. [Courses](#courses)
4. [Students](#students)
5. [Instructors](#instructors)
6. [Enrollments](#enrollments)
7. [Progress](#progress)

---

## Base URL

```
https://api.hancom-lms.mil (Future)
http://localhost:8000/api (Development)
```

---

## Authentication

### Login

**POST** `/api/auth/login`

Authenticate a user and receive an access token.

**Request Body:**
```json
{
  "username": "string",
  "password": "string",
  "userType": "student|instructor|admin"
}
```

**Response:**
```json
{
  "success": true,
  "token": "jwt_token_string",
  "user": {
    "id": "string",
    "username": "string",
    "userType": "string",
    "name": "string"
  }
}
```

**Status Codes:**
- `200 OK`: Successful login
- `401 Unauthorized`: Invalid credentials
- `400 Bad Request`: Missing required fields

---

### Logout

**POST** `/api/auth/logout`

Invalidate the current session token.

**Headers:**
```
Authorization: Bearer {token}
```

**Response:**
```json
{
  "success": true,
  "message": "Logged out successfully"
}
```

---

### Refresh Token

**POST** `/api/auth/refresh`

Refresh an expired access token.

**Request Body:**
```json
{
  "refreshToken": "string"
}
```

**Response:**
```json
{
  "success": true,
  "token": "new_jwt_token_string"
}
```

---

## Users

### Get Current User

**GET** `/api/users/me`

Get information about the currently authenticated user.

**Headers:**
```
Authorization: Bearer {token}
```

**Response:**
```json
{
  "id": "string",
  "username": "string",
  "name": "string",
  "userType": "string",
  "email": "string",
  "createdAt": "ISO8601 timestamp",
  "lastLogin": "ISO8601 timestamp"
}
```

---

### Update User Profile

**PUT** `/api/users/me`

Update current user's profile information.

**Headers:**
```
Authorization: Bearer {token}
```

**Request Body:**
```json
{
  "name": "string",
  "email": "string"
}
```

**Response:**
```json
{
  "success": true,
  "user": {
    "id": "string",
    "username": "string",
    "name": "string",
    "email": "string"
  }
}
```

---

### Change Password

**POST** `/api/users/me/password`

Change the current user's password.

**Headers:**
```
Authorization: Bearer {token}
```

**Request Body:**
```json
{
  "currentPassword": "string",
  "newPassword": "string"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Password changed successfully"
}
```

---

## Courses

### List All Courses

**GET** `/api/courses`

Retrieve a list of all available courses.

**Query Parameters:**
- `page` (integer): Page number (default: 1)
- `limit` (integer): Items per page (default: 10)
- `search` (string): Search by course name or code

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": "string",
      "code": "string",
      "name": "string",
      "description": "string",
      "duration": "string",
      "enrolledStudents": "number",
      "instructor": {
        "id": "string",
        "name": "string"
      }
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 10,
    "total": 50,
    "pages": 5
  }
}
```

---

### Get Course Details

**GET** `/api/courses/{courseId}`

Get detailed information about a specific course.

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "string",
    "code": "string",
    "name": "string",
    "description": "string",
    "duration": "string",
    "modules": [
      {
        "id": "string",
        "name": "string",
        "order": "number"
      }
    ],
    "enrolledStudents": "number",
    "instructor": {
      "id": "string",
      "name": "string",
      "rank": "string"
    }
  }
}
```

---

### Create Course

**POST** `/api/courses`

Create a new course (Instructor/Admin only).

**Headers:**
```
Authorization: Bearer {token}
```

**Request Body:**
```json
{
  "code": "string",
  "name": "string",
  "description": "string",
  "duration": "string",
  "modules": ["string"]
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "string",
    "code": "string",
    "name": "string",
    "createdAt": "ISO8601 timestamp"
  }
}
```

**Status Codes:**
- `201 Created`: Course created successfully
- `403 Forbidden`: Insufficient permissions
- `400 Bad Request`: Invalid data

---

### Update Course

**PUT** `/api/courses/{courseId}`

Update an existing course (Instructor/Admin only).

**Headers:**
```
Authorization: Bearer {token}
```

**Request Body:**
```json
{
  "name": "string",
  "description": "string",
  "duration": "string"
}
```

---

### Delete Course

**DELETE** `/api/courses/{courseId}`

Delete a course (Admin only).

**Headers:**
```
Authorization: Bearer {token}
```

**Response:**
```json
{
  "success": true,
  "message": "Course deleted successfully"
}
```

---

## Students

### List All Students

**GET** `/api/students`

Retrieve a list of all students (Instructor/Admin only).

**Query Parameters:**
- `page` (integer): Page number
- `limit` (integer): Items per page
- `search` (string): Search by name or military ID
- `unit` (string): Filter by unit

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": "string",
      "militaryId": "string",
      "name": "string",
      "rank": "string",
      "unit": "string",
      "enrolledCourses": ["string"]
    }
  ]
}
```

---

### Get Student Details

**GET** `/api/students/{studentId}`

Get detailed information about a specific student.

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "string",
    "militaryId": "string",
    "name": "string",
    "rank": "string",
    "unit": "string",
    "enrolledCourses": [
      {
        "courseId": "string",
        "courseName": "string",
        "progress": "number",
        "enrolledAt": "ISO8601 timestamp"
      }
    ]
  }
}
```

---

### Create Student

**POST** `/api/students`

Register a new student (Admin only).

**Request Body:**
```json
{
  "militaryId": "string",
  "name": "string",
  "rank": "string",
  "unit": "string",
  "password": "string"
}
```

---

### Update Student

**PUT** `/api/students/{studentId}`

Update student information (Admin only).

---

## Instructors

### List All Instructors

**GET** `/api/instructors`

Retrieve a list of all instructors.

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": "string",
      "instructorId": "string",
      "name": "string",
      "rank": "string",
      "specialty": "string",
      "assignedCourses": "number"
    }
  ]
}
```

---

### Get Instructor Details

**GET** `/api/instructors/{instructorId}`

Get detailed information about a specific instructor.

---

### Create Instructor

**POST** `/api/instructors`

Register a new instructor (Admin only).

---

## Enrollments

### Enroll Student in Course

**POST** `/api/enrollments`

Enroll a student in a course.

**Request Body:**
```json
{
  "studentId": "string",
  "courseId": "string"
}
```

---

### Get Student Enrollments

**GET** `/api/students/{studentId}/enrollments`

Get all courses a student is enrolled in.

---

## Progress

### Update Course Progress

**PUT** `/api/progress/{enrollmentId}`

Update a student's progress in a course.

**Request Body:**
```json
{
  "moduleId": "string",
  "completed": "boolean",
  "score": "number"
}
```

---

### Get Progress Report

**GET** `/api/progress/report`

Get a comprehensive progress report.

**Query Parameters:**
- `studentId` (string): Filter by student
- `courseId` (string): Filter by course
- `startDate` (string): Start date (ISO8601)
- `endDate` (string): End date (ISO8601)

---

## Dashboard Statistics

### Get Dashboard Stats

**GET** `/api/dashboard/stats`

Get dashboard statistics.

**Response:**
```json
{
  "success": true,
  "data": {
    "activeCourses": "number",
    "totalStudents": "number",
    "averageCompletionRate": "number",
    "totalInstructors": "number",
    "recentActivities": [
      {
        "type": "string",
        "message": "string",
        "timestamp": "ISO8601 timestamp"
      }
    ]
  }
}
```

---

## Error Responses

All endpoints may return error responses in the following format:

```json
{
  "success": false,
  "error": {
    "code": "string",
    "message": "string",
    "details": {}
  }
}
```

**Common Error Codes:**
- `AUTH_REQUIRED`: Authentication required
- `INVALID_TOKEN`: Invalid or expired token
- `FORBIDDEN`: Insufficient permissions
- `NOT_FOUND`: Resource not found
- `VALIDATION_ERROR`: Invalid request data
- `SERVER_ERROR`: Internal server error

---

## Rate Limiting

API requests are limited to:
- 1000 requests per hour for authenticated users
- 100 requests per hour for unauthenticated requests

**Rate Limit Headers:**
```
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 999
X-RateLimit-Reset: 1699876543
```

---

## Versioning

The API uses URL versioning. The current version is v1.

```
/api/v1/courses
/api/v1/students
```

---

## Webhooks (Future)

Webhooks will be available for:
- Course completion
- Student enrollment
- Progress milestones

---

## SDK and Libraries (Future)

Official SDKs will be available for:
- JavaScript/TypeScript
- Python
- Java

---

**Last Updated**: 2025-11-12  
**Version**: 1.0.0  
**Status**: Draft (Future Implementation)
