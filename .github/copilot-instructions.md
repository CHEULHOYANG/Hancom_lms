# Copilot Instructions for LMS (Learning Management System)

## Architecture Overview

This is a Classic ASP-based Learning Management System using SQL Server with EUC-KR charset. The system follows a traditional server-side rendering architecture with shared includes for common functionality.

### Core Components

- **Main Entry**: `main/index.asp` - Main landing page with course listings and study reviews
- **Authentication**: `include/set_loginfo.asp` - Session-based user authentication using cookies
- **Database**: `include/dbcon.asp` - SQL Server connection to `hancom_defense` database
- **Admin Panel**: `yes_rad/` - Complete administrative interface for course management

### Key Database Tables

- `member` - User accounts and profiles
- `LectMast` - Course/Package master records (패키지)  
- `LecturTab` - Individual lectures/courses (단과)
- `SectionTab` - Video sections within lectures
- `order_mast` - Purchase orders and enrollment records
- `oneone` - Q&A system for customer support

## Development Patterns

### Include File Structure
Always use these includes in order:
```asp
<!-- #include file="../include/set_loginfo.asp" -->  <!-- Auth first -->
<!-- #include file="../include/dbcon.asp" -->         <!-- DB connection second -->
```

### Security Patterns
- **SQL Injection Protection**: All pages automatically include `injection.asp` which blocks common attack patterns
- **Authentication Checks**: Use `isUsr` boolean and `str_User_ID` for user validation
- **Input Sanitization**: Use `Tag2Txt()` function for form data: `Tag2Txt(Request.Form("field"))`

### File Upload Handling
Uses ABCUpload4 component:
```asp
Set abc = Server.CreateObject("ABCUpload4.XForm")
abc.AbsolutePath = True
DirectoryPath = Server.MapPath("..") & "\ahdma\pds\"
```

### Payment Integration
- **Main Payment**: `elpay/pay_iframe.asp` - Handles course purchases
- **Payment Types**: Supports card, bank transfer, and free courses
- **Order System**: Creates unique order IDs using session + timestamp

## Video Viewer System

The `viwer/` directory contains the core video streaming functionality:

### Viewer Flow
1. **Permission Check**: `viewer_ready.asp` validates enrollment and purchase status
2. **Player Selection**: Routes to appropriate player (Kollus, MP4, Flash) based on content type
3. **Progress Tracking**: Auto-saves viewing progress every 10 seconds via AJAX

### Viewer Types
- `viewer_kollus.asp` - Kollus streaming platform integration
- `viewer_mp4.asp` - Direct MP4 playback
- `viewer_free.asp` - Free preview content

## Admin Interface (`yes_rad/`)

### Course Management
- `sub4/mst_*` - Package management (패키지)
- `sub4/dan_*` - Individual course management (단과) 
- `sub4/sec_*` - Video section management
- `sub3/` - Member management and enrollment

### Content Creation Flow
1. Create course in `dan_reg.asp` or package in `mst_reg.asp`
2. Add video sections via `sec_reg.asp`
3. Upload content files to `/ahdma/` directory structure
4. Set permissions and pricing

## Development Guidelines

### Character Encoding
- **Always**: Use EUC-KR charset in all files
- **HTML Meta**: `<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">`
- **ASP Settings**: Files start with `Session.Codepage = 949` and `Response.CharSet = "EUC-KR"`

### Error Handling Pattern
```asp
If dr.eof Or dr.bof Then
    response.write"<script>"
    response.write"alert('데이터오류!!');"
    response.write"history.back();"
    response.write"</script>"
    response.end
End if
```

### AJAX Patterns
Uses `xmlhttp.js` for AJAX calls:
```javascript
$.ajax({
    url: "../xml/some_action.asp",
    type: "POST",
    data: {"param": value},
    dataType: "text"
});
```

### Configuration System
- Site settings stored in `/ahdma/cfgini/config.cfg` text file
- Loaded via `siteinfo.asp` into global variables
- Contains payment gateway settings, site info, and feature flags

## File Organization

- `/include/` - Shared components (auth, DB, CSS, JS)
- `/study/` - Student-facing course interfaces  
- `/my/` - Student dashboard and progress tracking
- `/member/` - Registration and account management
- `/elpay/` - Payment processing
- `/cs/` - Customer service Q&A system
- `/ahdma/` - File storage (uploads, images, videos)

## Common Debugging

- Check `order_mast` table for enrollment status when video access fails
- Verify session cookies for authentication issues  
- Monitor `/ahdma/` directory permissions for file upload problems
- Use SQL Server Profiler to debug stored procedures like `sp_Login_Usr`