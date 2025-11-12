# MND LMS ¼³°è»ç¾ç¼­

## ? ½Ã½ºÅÛ ¼³°è °³¿ä

### 1.1 ¼³°è ¸ñÇ¥
- **»ç¿ë¼º**: Á÷°üÀûÀÌ°í Á¢±ÙÇÏ±â ½¬¿î ÀÎÅÍÆäÀÌ½º
- **È®Àå¼º**: ÇâÈÄ ±â´É Ãß°¡¿¡ À¯¿¬ÇÑ ±¸Á¶
- **º¸¾È¼º**: ±¹¹æºÎ º¸¾È ±âÁØ¿¡ ºÎÇÕÇÏ´Â ¼³°è
- **¼º´É**: ´ë¿ë·® µ¿½Ã Á¢¼ÓÀÚ Ã³¸® °¡´É

### 1.2 ¼³°è ¿øÄ¢
- **¸ðµâÈ­**: ±â´Éº° µ¶¸³ÀûÀÎ ¸ðµâ ¼³°è
- **Àç»ç¿ë¼º**: °øÅë ÄÄÆ÷³ÍÆ®ÀÇ Àç»ç¿ë ±Ø´ëÈ­
- **À¯Áöº¸¼ö¼º**: ÄÚµåÀÇ °¡µ¶¼º°ú À¯Áöº¸¼ö ¿ëÀÌ¼º
- **Ç¥ÁØ ÁØ¼ö**: À¥ Ç¥ÁØ ¹× Á¢±Ù¼º °¡ÀÌµå¶óÀÎ ÁØ¼ö

## ?? ½Ã½ºÅÛ ¾ÆÅ°ÅØÃ³ ¼³°è

### 2.1 3-Tier ¾ÆÅ°ÅØÃ³
```
¦£¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¤
¦¢                   Presentation Tier                     ¦¢
¦¢  ¦£¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¤  ¦£¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¤  ¦£¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¤ ¦¢
¦¢  ¦¢   Web UI    ¦¢  ¦¢  Mobile UI  ¦¢  ¦¢   Admin Panel   ¦¢ ¦¢
¦¢  ¦¦¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¥  ¦¦¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¥  ¦¦¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¥ ¦¢
¦¦¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¥
                              ¦¢
¦£¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¤
¦¢                    Application Tier                     ¦¢
¦¢  ¦£¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¤  ¦£¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¤  ¦£¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¤ ¦¢
¦¢  ¦¢    Views    ¦¢  ¦¢   Models    ¦¢  ¦¢   Controllers   ¦¢ ¦¢
¦¢  ¦¦¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¥  ¦¦¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¥  ¦¦¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¥ ¦¢
¦¦¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¥
                              ¦¢
¦£¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¤
¦¢                     Data Tier                           ¦¢
¦¢  ¦£¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¤  ¦£¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¤  ¦£¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¤ ¦¢
¦¢  ¦¢ Primary DB  ¦¢  ¦¢  Cache DB   ¦¢  ¦¢   File Storage  ¦¢ ¦¢
¦¢  ¦¦¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¥  ¦¦¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¥  ¦¦¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¥ ¦¢
¦¦¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¥
```

### 2.2 ¸ðµâ ±¸Á¶ ¼³°è
```
mnd_lms_simple/
¦§¦¡¦¡ models/              # µ¥ÀÌÅÍ ¸ðµ¨
¦¢   ¦§¦¡¦¡ user.py         # »ç¿ëÀÚ ¸ðµ¨
¦¢   ¦§¦¡¦¡ course.py       # °­ÀÇ ¸ðµ¨
¦¢   ¦§¦¡¦¡ enrollment.py   # ¼ö°­ ¸ðµ¨
¦¢   ¦¦¦¡¦¡ community.py    # Ä¿¹Â´ÏÆ¼ ¸ðµ¨
¦§¦¡¦¡ views/              # ºñÁî´Ï½º ·ÎÁ÷
¦¢   ¦§¦¡¦¡ auth_views.py   # ÀÎÁõ °ü·Ã
¦¢   ¦§¦¡¦¡ course_views.py # °­ÀÇ °ü·Ã
¦¢   ¦§¦¡¦¡ admin_views.py  # °ü¸®ÀÚ °ü·Ã
¦¢   ¦¦¦¡¦¡ api_views.py    # API °ü·Ã
¦§¦¡¦¡ templates/          # È­¸é ÅÛÇÃ¸´
¦¢   ¦§¦¡¦¡ base/          # ±âº» ÅÛÇÃ¸´
¦¢   ¦§¦¡¦¡ auth/          # ÀÎÁõ °ü·Ã
¦¢   ¦§¦¡¦¡ course/        # °­ÀÇ °ü·Ã
¦¢   ¦¦¦¡¦¡ admin/         # °ü¸®ÀÚ °ü·Ã
¦¦¦¡¦¡ static/            # Á¤Àû ÆÄÀÏ
    ¦§¦¡¦¡ css/           # ½ºÅ¸ÀÏ½ÃÆ®
    ¦§¦¡¦¡ js/            # ÀÚ¹Ù½ºÅ©¸³Æ®
    ¦¦¦¡¦¡ images/        # ÀÌ¹ÌÁö ÆÄÀÏ
```

## ? UI/UX ¼³°è

### 3.1 µðÀÚÀÎ ½Ã½ºÅÛ

#### »ö»ó ÆÈ·¹Æ®
```css
:root {
  /* Primary Colors */
  --primary-blue: #1e3a8a;      /* ±¹¹æºÎ ¸ÞÀÎ ÄÃ·¯ */
  --primary-gray: #374151;      /* º¸Á¶ ÄÃ·¯ */
  
  /* Secondary Colors */
  --accent-red: #dc2626;        /* ¾×¼¾Æ® ÄÃ·¯ */
  --success-green: #10b981;     /* ¼º°ø ¸Þ½ÃÁö */
  --warning-yellow: #f59e0b;    /* °æ°í ¸Þ½ÃÁö */
  --error-red: #ef4444;         /* ¿À·ù ¸Þ½ÃÁö */
  
  /* Neutral Colors */
  --gray-50: #f9fafb;
  --gray-100: #f3f4f6;
  --gray-200: #e5e7eb;
  --gray-300: #d1d5db;
  --gray-400: #9ca3af;
  --gray-500: #6b7280;
  --gray-600: #4b5563;
  --gray-700: #374151;
  --gray-800: #1f2937;
  --gray-900: #111827;
}
```

#### Å¸ÀÌÆ÷±×·¡ÇÇ
```css
/* Font Family */
font-family: 'Malgun Gothic', '¸¼Àº °íµñ', -apple-system, BlinkMacSystemFont, sans-serif;

/* Font Sizes */
--text-xs: 0.75rem;     /* 12px */
--text-sm: 0.875rem;    /* 14px */
--text-base: 1rem;      /* 16px */
--text-lg: 1.125rem;    /* 18px */
--text-xl: 1.25rem;     /* 20px */
--text-2xl: 1.5rem;     /* 24px */
--text-3xl: 1.875rem;   /* 30px */
--text-4xl: 2.25rem;    /* 36px */
```

### 3.2 ¹ÝÀÀÇü µðÀÚÀÎ
```css
/* Breakpoints */
@media (min-width: 640px) { /* sm */ }
@media (min-width: 768px) { /* md */ }
@media (min-width: 1024px) { /* lg */ }
@media (min-width: 1280px) { /* xl */ }
@media (min-width: 1536px) { /* 2xl */ }

/* Grid System */
.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 1rem;
}

.grid {
  display: grid;
  gap: 1rem;
}

.grid-cols-1 { grid-template-columns: repeat(1, 1fr); }
.grid-cols-2 { grid-template-columns: repeat(2, 1fr); }
.grid-cols-3 { grid-template-columns: repeat(3, 1fr); }
.grid-cols-4 { grid-template-columns: repeat(4, 1fr); }
```

### 3.3 ÄÄÆ÷³ÍÆ® ¼³°è

#### Button Component
```css
.btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 0.5rem 1rem;
  border-radius: 0.375rem;
  font-weight: 600;
  transition: all 0.3s ease;
  cursor: pointer;
  border: none;
  text-decoration: none;
}

.btn-primary {
  background: linear-gradient(135deg, var(--primary-blue), var(--primary-gray));
  color: white;
}

.btn-primary:hover {
  transform: translateY(-2px);
  box-shadow: 0 10px 20px rgba(30, 58, 138, 0.2);
}
```

#### Card Component
```css
.card {
  background: white;
  border-radius: 0.75rem;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
  padding: 1.5rem;
  transition: transform 0.3s ease;
}

.card:hover {
  transform: translateY(-4px);
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
}
```

## ?? µ¥ÀÌÅÍº£ÀÌ½º ¼³°è

### 4.1 ERD (Entity Relationship Diagram)
```
¦£¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¤    ¦£¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¤
¦¢    CustomUser       ¦¢    ¦¢    Course           ¦¢
¦§¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦©    ¦§¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦©
¦¢ id (PK)            ¦¢    ¦¢ id (PK)            ¦¢
¦¢ username           ¦¢    ¦¢ title              ¦¢
¦¢ email              ¦¢    ¦¢ description        ¦¢
¦¢ first_name         ¦¢    ¦¢ instructor         ¦¢
¦¢ last_name          ¦¢    ¦¢ category_id (FK)   ¦¢
¦¢ real_name          ¦¢    ¦¢ level              ¦¢
¦¢ phone              ¦¢    ¦¢ status             ¦¢
¦¢ grade              ¦¢    ¦¢ duration_weeks     ¦¢
¦¢ login_count        ¦¢    ¦¢ max_students       ¦¢
¦¢ total_study_time   ¦¢    ¦¢ current_students   ¦¢
¦¢ is_active          ¦¢    ¦¢ price              ¦¢
¦¢ is_staff           ¦¢    ¦¢ is_featured        ¦¢
¦¢ created_at         ¦¢    ¦¢ start_date         ¦¢
¦¢ updated_at         ¦¢    ¦¢ end_date           ¦¢
¦¦¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¥    ¦¢ created_at         ¦¢
           ¦¢                ¦¢ updated_at         ¦¢
           ¦¢                ¦¦¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¥
           ¦¢                          ¦¢
           ¦¢                          ¦¢
           ¦¢                ¦£¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¤
           ¦¢                ¦¢  CourseCategory     ¦¢
           ¦¢                ¦§¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦©
           ¦¢                ¦¢ id (PK)            ¦¢
           ¦¢                ¦¢ name               ¦¢
           ¦¢                ¦¢ description        ¦¢
           ¦¢                ¦¢ order              ¦¢
           ¦¢                ¦¢ is_active          ¦¢
           ¦¢                ¦¢ created_at         ¦¢
           ¦¢                ¦¦¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¥
           ¦¢
    ¦£¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¤
    ¦¢    Enrollment       ¦¢
    ¦§¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦©
    ¦¢ id (PK)            ¦¢
    ¦¢ student_id (FK)    ¦¢¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¥
    ¦¢ course_id (FK)     ¦¢¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¥
    ¦¢ status             ¦¢
    ¦¢ progress           ¦¢
    ¦¢ enrolled_at        ¦¢
    ¦¢ completed_at       ¦¢
    ¦¦¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¡¦¥
```

### 4.2 ÀÎµ¦½º Àü·«
```sql
-- ¼º´É ÃÖÀûÈ­¸¦ À§ÇÑ º¹ÇÕ ÀÎµ¦½º
CREATE INDEX idx_course_status_featured ON mnd_lms_simple_course(status, is_featured);
CREATE INDEX idx_enrollment_student_status ON mnd_lms_simple_enrollment(student_id, status);
CREATE INDEX idx_post_board_created ON mnd_lms_simple_post(board_id, created_at DESC);

-- °Ë»öÀ» À§ÇÑ Àü¹® °Ë»ö ÀÎµ¦½º
CREATE INDEX idx_course_title_search ON mnd_lms_simple_course 
USING gin(to_tsvector('korean', title));
```

## ? º¸¾È ¼³°è

### 5.1 ÀÎÁõ ¹× ±ÇÇÑ ¼³°è
```python
# ±ÇÇÑ µ¥ÄÚ·¹ÀÌÅÍ ¼³°è
def require_login(view_func):
    @wraps(view_func)
    def wrapper(request, *args, **kwargs):
        if not request.user.is_authenticated:
            return redirect('login')
        return view_func(request, *args, **kwargs)
    return wrapper

def require_admin(view_func):
    @wraps(view_func)
    def wrapper(request, *args, **kwargs):
        if not request.user.is_staff:
            raise PermissionDenied
        return view_func(request, *args, **kwargs)
    return wrapper
```

### 5.2 µ¥ÀÌÅÍ °ËÁõ ¼³°è
```python
# Form Validation
class CourseForm(forms.ModelForm):
    class Meta:
        model = Course
        fields = ['title', 'description', 'instructor', 'category']
        
    def clean_title(self):
        title = self.cleaned_data.get('title')
        if len(title) < 5:
            raise ValidationError('Á¦¸ñÀº 5ÀÚ ÀÌ»óÀÌ¾î¾ß ÇÕ´Ï´Ù.')
        return title

    def clean_max_students(self):
        max_students = self.cleaned_data.get('max_students')
        if max_students < 1:
            raise ValidationError('ÃÖ´ë ¼ö°­»ýÀº 1¸í ÀÌ»óÀÌ¾î¾ß ÇÕ´Ï´Ù.')
        return max_students
```

## ? API ¼³°è

### 6.1 REST API ¼³°è
```python
# API ¿£µåÆ÷ÀÎÆ® ¼³°è
urlpatterns = [
    # Authentication
    path('api/auth/login/', views.LoginAPIView.as_view()),
    path('api/auth/logout/', views.LogoutAPIView.as_view()),
    
    # Courses
    path('api/courses/', views.CourseListAPIView.as_view()),
    path('api/courses/<int:pk>/', views.CourseDetailAPIView.as_view()),
    
    # Enrollments
    path('api/enrollments/', views.EnrollmentListAPIView.as_view()),
    path('api/enrollments/enroll/', views.EnrollAPIView.as_view()),
    
    # User Profile
    path('api/profile/', views.UserProfileAPIView.as_view()),
]
```

### 6.2 API ÀÀ´ä Çü½Ä
```json
{
  "success": true,
  "data": {
    "courses": [
      {
        "id": 1,
        "title": "Advanced Strategic Planning",
        "description": "Comprehensive strategic planning course",
        "instructor": "Colonel Kim",
        "category": {
          "id": 1,
          "name": "Strategic Planning"
        },
        "level": "advanced",
        "duration_weeks": 8,
        "current_students": 32,
        "max_students": 50,
        "is_featured": true,
        "created_at": "2025-11-12T10:00:00Z"
      }
    ]
  },
  "pagination": {
    "page": 1,
    "per_page": 20,
    "total": 45,
    "total_pages": 3
  },
  "message": "°­ÀÇ ¸ñ·ÏÀ» ¼º°øÀûÀ¸·Î Á¶È¸Çß½À´Ï´Ù."
}
```

## ? ¼º´É ¼³°è

### 7.1 Ä³½Ì Àü·«
```python
# ºä ·¹º§ Ä³½Ì
@cache_page(60 * 15)  # 15ºÐ Ä³½Ì
def course_list(request):
    courses = Course.objects.filter(status='published')
    return render(request, 'courses/list.html', {'courses': courses})

# ÅÛÇÃ¸´ ÇÁ·¡±×¸ÕÆ® Ä³½Ì
{% load cache %}
{% cache 500 course_sidebar request.user.username %}
    <!-- »çÀÌµå¹Ù ³»¿ë -->
{% endcache %}
```

### 7.2 Äõ¸® ÃÖÀûÈ­
```python
# N+1 ¹®Á¦ ÇØ°á
def get_courses_with_categories():
    return Course.objects.select_related('category').prefetch_related(
        'enrollments__student'
    ).filter(status='published')

# ´ë¿ë·® µ¥ÀÌÅÍ Ã³¸®
def export_users_csv():
    response = HttpResponse(content_type='text/csv')
    writer = csv.writer(response)
    
    # iterator()¸¦ »ç¿ëÇÏ¿© ¸Þ¸ð¸® È¿À²Àû Ã³¸®
    for user in CustomUser.objects.iterator(chunk_size=1000):
        writer.writerow([user.username, user.email, user.grade])
    
    return response
```

## ? ¸ð´ÏÅÍ¸µ ¼³°è

### 8.1 ·Î±ë ¼³°è
```python
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'verbose': {
            'format': '{levelname} {asctime} {module} {process:d} {thread:d} {message}',
            'style': '{',
        },
    },
    'handlers': {
        'file': {
            'level': 'INFO',
            'class': 'logging.handlers.RotatingFileHandler',
            'filename': '/var/log/django/mnd_lms.log',
            'maxBytes': 1024*1024*15,  # 15MB
            'backupCount': 10,
            'formatter': 'verbose',
        },
    },
    'loggers': {
        'mnd_lms_simple': {
            'handlers': ['file'],
            'level': 'INFO',
            'propagate': True,
        },
    },
}
```

### 8.2 Çï½ºÃ¼Å© ¼³°è
```python
def health_check(request):
    checks = {
        'database': check_database(),
        'cache': check_cache(),
        'disk_space': check_disk_space(),
        'memory': check_memory_usage(),
    }
    
    all_healthy = all(checks.values())
    status_code = 200 if all_healthy else 503
    
    return JsonResponse({
        'status': 'healthy' if all_healthy else 'unhealthy',
        'timestamp': timezone.now().isoformat(),
        'checks': checks
    }, status=status_code)
```

---

**¹®¼­ Á¤º¸**
- ÀÛ¼ºÀÏ: 2025³â 11¿ù 12ÀÏ
- ÀÛ¼ºÀÚ: MND LMS ¼³°èÆÀ
- °ËÅäÀÚ: ½Ã½ºÅÛ ¾ÆÅ°ÅØÆ®
- ½ÂÀÎÀÚ: ±â¼ú´ã´ç°ü
- ¹öÀü: 1.0