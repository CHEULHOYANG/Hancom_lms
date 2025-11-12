# LMS 데이터 마이그레이션 계획

## 1. 마이그레이션 전략 개요

### 단계별 마이그레이션 접근법
1. **분석 단계**: 기존 ASP 데이터베이스 스키마 및 데이터 분석
2. **설계 단계**: 새 Django 모델과의 매핑 관계 정의
3. **추출 단계**: 기존 데이터 추출 및 정제
4. **변환 단계**: 데이터 형식 변환 및 정규화
5. **적재 단계**: 새 시스템으로 데이터 이전
6. **검증 단계**: 데이터 무결성 및 기능 검증

## 2. 데이터베이스 스키마 매핑

### 기존 ASP 테이블 → 새 Django 테이블 매핑

```python
# migration_mapping.py

SCHEMA_MAPPING = {
    # 사용자 관련
    'member': {
        'target_table': 'auth_user + user_profiles',
        'mapping': {
            'id': 'username',
            'pwd': 'password',  # Argon2로 재해싱 필요
            'name': 'first_name + last_name',
            'juminno1': 'user_profiles.birth_date',  # 주민번호 → 생년월일 변환
            'juminno2': None,  # 보안상 이전하지 않음
            'tel1': 'user_profiles.phone',
            'tel2': 'user_profiles.phone',  # 중복 제거
            'email': 'email',
            'regdate': 'date_joined',
            'sp1': 'user_profiles.role',  # 역할 매핑
            'sp2': None,  # 사용하지 않음
            'sp3': None,
            'memo': None,
        }
    },
    
    # 강의 관련
    'LectMast': {
        'target_table': 'courses',
        'mapping': {
            'idx': 'id',
            'strnm': 'title',
            'intprice': 'price',
            'intgigan': 'duration_hours',
            'strheader': 'description',
            'sub_title': 'detailed_description',
            'icon': 'tags',  # JSON 배열로 변환
            'sajin': 'thumbnail',
            'recom': 'is_featured',
            'mem_group': None,  # 새 시스템에서는 다른 방식으로 처리
            'teacher': 'instructor_id',  # FK 매핑
            'state': 'is_published',
            'ordn': 'order_index',
        }
    },
    
    'LecturTab': {
        'target_table': 'courses',
        'mapping': {
            'idx': 'id',
            'strnm': 'title',
            'strteach': 'instructor.first_name',
            'tinfo': 'detailed_description',
            'intprice': 'price',
            'intgigan': 'duration_hours',
            'categbn': 'category_id',
            'sajin': 'thumbnail',
            'ordn': 'order_index',
            'ca1': 'category_id',  # 카테고리 재구성
            'ca2': None,
            'state': 'is_published',
        }
    },
    
    'SectionTab': {
        'target_table': 'course_sections + lessons',
        'mapping': {
            'idx': 'lessons.id',
            'l_idx': 'course_sections.course_id',
            'strnm': 'lessons.title',
            'ordnum': 'lessons.order_index',
            'strtime': 'lessons.video_duration',  # 시:분 → 초 변환
            'movlink': 'lessons.video_url',
            'flshlink': None,  # Flash 비디오는 지원하지 않음
            'lecsum': 'lessons.description',
            'lecsrc': None,
            'freegbn': 'lessons.is_free',
            'mckey': None,
        }
    },
    
    # 주문/수강 관련
    'order_mast': {
        'target_table': 'orders + order_items + enrollments',
        'mapping': {
            'idx': 'orders.id',
            'id': 'orders.user_id',
            'order_id': 'orders.order_number',
            'tabidx': 'order_items.course_id',
            'buygbn': None,  # 새 시스템에서는 단순화
            'paytime': 'orders.created_at',
            'sday': 'enrollments.enrollment_date',
            'eday': 'enrollments.expiry_date',
            'state': 'orders.status',
            'holdgbn': 'enrollments.status',
            'cash': 'orders.final_amount',
        }
    },
    
    # 게시판 관련
    'notice': {
        'target_table': 'notices',
        'mapping': {
            'idx': 'id',
            'jemok': 'title',
            'neyong': 'content',
            'wday': 'created_at',
            'readnum': 'views',
            'notice': 'is_important',
        }
    },
    
    'oneone': {
        'target_table': 'qna_questions + qna_answers',
        'mapping': {
            'qidx': 'qna_questions.id',
            'quserid': 'qna_questions.user_id',
            'qgbn': 'qna_questions.category',
            'qtitle': 'qna_questions.title',
            'qcont': 'qna_questions.content',
            'qansgbn': 'qna_questions.status',
            'qanscont': 'qna_answers.content',
            'regdate': 'qna_questions.created_at',
            'ansdate': 'qna_answers.created_at',
        }
    },
}
```

## 3. 데이터 추출 스크립트

```python
# scripts/extract_data.py
import pyodbc
import json
import csv
from datetime import datetime
import os

class ASPDataExtractor:
    def __init__(self, connection_string):
        self.connection_string = connection_string
        self.connection = None
        
    def connect(self):
        """ASP 데이터베이스에 연결"""
        try:
            self.connection = pyodbc.connect(self.connection_string)
            print("데이터베이스 연결 성공")
        except Exception as e:
            print(f"데이터베이스 연결 실패: {e}")
            raise
    
    def extract_users(self):
        """사용자 데이터 추출"""
        query = """
        SELECT idx, id, pwd, name, juminno1, juminno2, tel1, tel2, email,
               zipcode1, zipcode2, juso1, juso2, regdate, state, sp1, sp2, sp3
        FROM member
        WHERE state = 1  -- 활성 사용자만
        ORDER BY idx
        """
        
        cursor = self.connection.cursor()
        cursor.execute(query)
        
        users = []
        for row in cursor.fetchall():
            user_data = {
                'idx': row.idx,
                'username': row.id,
                'password_old': row.pwd,  # 재해싱 필요
                'name': row.name,
                'birth_year': self.extract_birth_year(row.juminno1),
                'phone': self.format_phone(row.tel1, row.tel2),
                'email': row.email,
                'address': self.format_address(row.zipcode1, row.zipcode2, row.juso1, row.juso2),
                'date_joined': row.regdate,
                'role': self.map_user_role(row.sp1),
                'is_active': row.state == 1,
            }
            users.append(user_data)
        
        return users
    
    def extract_courses(self):
        """강의 데이터 추출 (패키지와 단과 통합)"""
        # 패키지 강의
        package_query = """
        SELECT idx, strnm, intprice, intgigan, strheader, sub_title,
               icon, sajin, recom, teacher, state, ordn, 'package' as course_type
        FROM LectMast
        WHERE state = 1
        """
        
        # 단과 강의
        individual_query = """
        SELECT idx, strnm, intprice, intgigan, tinfo as strheader, 
               sub_title, icon, sajin, 0 as recom, teach_id as teacher,
               state, ordn, 'individual' as course_type
        FROM LecturTab
        WHERE state = 1
        """
        
        cursor = self.connection.cursor()
        courses = []
        
        # 패키지 강의 추출
        cursor.execute(package_query)
        for row in cursor.fetchall():
            course_data = self.format_course_data(row)
            courses.append(course_data)
        
        # 단과 강의 추출
        cursor.execute(individual_query)
        for row in cursor.fetchall():
            course_data = self.format_course_data(row)
            courses.append(course_data)
        
        return courses
    
    def extract_sections_and_lessons(self):
        """섹션과 레슨 데이터 추출"""
        query = """
        SELECT s.idx, s.l_idx, s.strnm, s.ordnum, s.strtime,
               s.movlink, s.flshlink, s.lecsum, s.lecsrc, s.freegbn,
               l.strnm as course_title
        FROM SectionTab s
        LEFT JOIN LecturTab l ON s.l_idx = l.idx
        ORDER BY s.l_idx, s.ordnum
        """
        
        cursor = self.connection.cursor()
        cursor.execute(query)
        
        lessons = []
        for row in cursor.fetchall():
            lesson_data = {
                'id': row.idx,
                'course_id': row.l_idx,
                'title': row.strnm,
                'order_index': row.ordnum,
                'duration_seconds': self.convert_time_to_seconds(row.strtime),
                'video_url': row.movlink,
                'description': row.lecsum,
                'is_free': row.freegbn == 1,
                'content_type': 'video' if row.movlink else 'text',
            }
            lessons.append(lesson_data)
        
        return lessons
    
    def extract_orders_and_enrollments(self):
        """주문 및 수강신청 데이터 추출"""
        query = """
        SELECT o.idx, o.id, o.order_id, o.tabidx, o.buygbn,
               o.paytime, o.sday, o.eday, o.state, o.holdgbn, o.cash,
               CASE 
                   WHEN o.buygbn = 0 THEN 'package'
                   WHEN o.buygbn = 1 THEN 'individual'
                   ELSE 'unknown'
               END as course_type
        FROM order_mast o
        WHERE o.state = 0  -- 정상 주문만
        ORDER BY o.paytime DESC
        """
        
        cursor = self.connection.cursor()
        cursor.execute(query)
        
        orders = []
        for row in cursor.fetchall():
            order_data = {
                'id': row.idx,
                'user_username': row.id,
                'order_number': row.order_id,
                'course_id': row.tabidx,
                'course_type': row.course_type,
                'amount': float(row.cash) if row.cash else 0,
                'payment_date': row.paytime,
                'enrollment_start': row.sday,
                'enrollment_end': row.eday,
                'status': self.map_order_status(row.state, row.holdgbn),
            }
            orders.append(order_data)
        
        return orders
    
    def extract_notices(self):
        """공지사항 데이터 추출"""
        query = """
        SELECT idx, jemok, neyong, wday, readnum, notice
        FROM notice
        ORDER BY wday DESC
        """
        
        cursor = self.connection.cursor()
        cursor.execute(query)
        
        notices = []
        for row in cursor.fetchall():
            notice_data = {
                'id': row.idx,
                'title': row.jemok,
                'content': row.neyong,
                'created_at': row.wday,
                'views': row.readnum,
                'is_important': row.notice == 1,
            }
            notices.append(notice_data)
        
        return notices
    
    def extract_qna(self):
        """Q&A 데이터 추출"""
        query = """
        SELECT qidx, quserid, qgbn, qtitle, qcont, qansgbn, qanscont,
               regdate, ansdate, files1, files2
        FROM oneone
        ORDER BY regdate DESC
        """
        
        cursor = self.connection.cursor()
        cursor.execute(query)
        
        qna_data = []
        for row in cursor.fetchall():
            qna_item = {
                'question_id': row.qidx,
                'user_username': row.quserid,
                'category': self.map_qna_category(row.qgbn),
                'title': row.qtitle,
                'content': row.qcont,
                'status': self.map_qna_status(row.qansgbn),
                'answer_content': row.qanscont,
                'created_at': row.regdate,
                'answered_at': row.ansdate,
                'attachments': self.format_attachments(row.files1, row.files2),
            }
            qna_data.append(qna_item)
        
        return qna_data
    
    # 유틸리티 메서드들
    def extract_birth_year(self, juminno1):
        """주민번호에서 생년 추출"""
        if not juminno1 or len(juminno1) < 6:
            return None
        
        year_part = juminno1[:2]
        try:
            year = int(year_part)
            # 2자리 연도를 4자리로 변환
            if year >= 0 and year <= 22:  # 2000년대생
                return 2000 + year
            else:  # 1900년대생
                return 1900 + year
        except:
            return None
    
    def format_phone(self, tel1, tel2):
        """전화번호 형식 통합"""
        if tel1 and tel1.strip():
            return tel1.strip()
        elif tel2 and tel2.strip():
            return tel2.strip()
        return ""
    
    def convert_time_to_seconds(self, time_str):
        """시:분 형식을 초로 변환"""
        if not time_str:
            return 0
        
        try:
            parts = time_str.split(':')
            if len(parts) == 2:
                hours, minutes = int(parts[0]), int(parts[1])
                return hours * 3600 + minutes * 60
        except:
            pass
        
        return 0
    
    def map_user_role(self, sp1):
        """사용자 역할 매핑"""
        role_mapping = {
            '1': 'student',
            '2': 'instructor',
            '3': 'admin',
        }
        return role_mapping.get(str(sp1), 'student')
    
    def map_order_status(self, state, holdgbn):
        """주문 상태 매핑"""
        if holdgbn == 1:
            return 'suspended'
        elif state == 0:
            return 'active'
        else:
            return 'expired'
    
    def save_to_json(self, data, filename):
        """데이터를 JSON 파일로 저장"""
        os.makedirs('migration_data', exist_ok=True)
        filepath = f'migration_data/{filename}'
        
        with open(filepath, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2, default=str)
        
        print(f"데이터 저장 완료: {filepath} ({len(data)}건)")

def main():
    # 연결 문자열 설정
    connection_string = (
        "DRIVER={ODBC Driver 17 for SQL Server};"
        "SERVER=HANCOMELEARNING\\HANCOM_DEFENSE;"
        "DATABASE=hancom_defense;"
        "UID=hancomsqladmin;"
        "PWD=zoavjtm!23;"
        "CHARSET=UTF8;"
    )
    
    extractor = ASPDataExtractor(connection_string)
    extractor.connect()
    
    try:
        # 데이터 추출
        print("사용자 데이터 추출 중...")
        users = extractor.extract_users()
        extractor.save_to_json(users, 'users.json')
        
        print("강의 데이터 추출 중...")
        courses = extractor.extract_courses()
        extractor.save_to_json(courses, 'courses.json')
        
        print("레슨 데이터 추출 중...")
        lessons = extractor.extract_sections_and_lessons()
        extractor.save_to_json(lessons, 'lessons.json')
        
        print("주문/수강신청 데이터 추출 중...")
        orders = extractor.extract_orders_and_enrollments()
        extractor.save_to_json(orders, 'orders.json')
        
        print("공지사항 데이터 추출 중...")
        notices = extractor.extract_notices()
        extractor.save_to_json(notices, 'notices.json')
        
        print("Q&A 데이터 추출 중...")
        qna = extractor.extract_qna()
        extractor.save_to_json(qna, 'qna.json')
        
        print("모든 데이터 추출 완료!")
        
    except Exception as e:
        print(f"데이터 추출 중 오류 발생: {e}")
    
    finally:
        if extractor.connection:
            extractor.connection.close()

if __name__ == "__main__":
    main()
```

## 4. 데이터 변환 및 적재 스크립트

```python
# scripts/migrate_data.py
import json
import os
import django
from datetime import datetime
from django.utils import timezone
from django.db import transaction
import argon2

# Django 설정
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings.production')
django.setup()

from django.contrib.auth import get_user_model
from courses.models import Course, CourseCategory, CourseSection, Lesson
from enrollments.models import Enrollment, LessonProgress
from payments.models import Order, OrderItem
from notices.models import Notice
from qna.models import QnAQuestion, QnAAnswer

User = get_user_model()

class DataMigrator:
    def __init__(self, data_dir='migration_data'):
        self.data_dir = data_dir
        self.password_hasher = argon2.PasswordHasher()
        
    def load_json_data(self, filename):
        """JSON 파일에서 데이터 로드"""
        filepath = os.path.join(self.data_dir, filename)
        with open(filepath, 'r', encoding='utf-8') as f:
            return json.load(f)
    
    @transaction.atomic
    def migrate_users(self):
        """사용자 데이터 마이그레이션"""
        print("사용자 데이터 마이그레이션 시작...")
        
        users_data = self.load_json_data('users.json')
        
        created_count = 0
        error_count = 0
        
        for user_data in users_data:
            try:
                # 중복 체크
                if User.objects.filter(username=user_data['username']).exists():
                    print(f"중복 사용자 건너뜀: {user_data['username']}")
                    continue
                
                # 비밀번호 재해싱 (기존 MD5를 Argon2로)
                # 실제로는 사용자에게 비밀번호 재설정을 요청하는 것이 더 안전
                temp_password = 'TempPassword123!'  # 임시 비밀번호
                
                user = User.objects.create_user(
                    username=user_data['username'],
                    email=user_data['email'],
                    password=temp_password,
                    first_name=user_data['name'][:30],  # Django 제한
                    role=user_data['role'],
                    phone=user_data['phone'],
                    birth_date=self.parse_birth_date(user_data.get('birth_year')),
                    date_joined=timezone.make_aware(
                        datetime.fromisoformat(user_data['date_joined'])
                    ) if user_data.get('date_joined') else timezone.now(),
                    is_active=user_data.get('is_active', True)
                )
                
                created_count += 1
                
                if created_count % 100 == 0:
                    print(f"사용자 {created_count}명 마이그레이션 완료...")
                    
            except Exception as e:
                error_count += 1
                print(f"사용자 마이그레이션 오류 ({user_data['username']}): {e}")
        
        print(f"사용자 마이그레이션 완료: {created_count}명 생성, {error_count}건 오류")
    
    @transaction.atomic
    def migrate_courses(self):
        """강의 데이터 마이그레이션"""
        print("강의 데이터 마이그레이션 시작...")
        
        courses_data = self.load_json_data('courses.json')
        
        # 기본 카테고리 생성
        default_category, _ = CourseCategory.objects.get_or_create(
            name='일반',
            defaults={'description': '기본 카테고리'}
        )
        
        created_count = 0
        error_count = 0
        
        for course_data in courses_data:
            try:
                # 강사 찾기
                instructor = User.objects.filter(
                    role='instructor'
                ).first()
                
                if not instructor:
                    # 기본 강사 생성
                    instructor = User.objects.create_user(
                        username='default_instructor',
                        email='instructor@example.com',
                        password='TempPassword123!',
                        role='instructor'
                    )
                
                course = Course.objects.create(
                    title=course_data['title'][:255],
                    description=course_data.get('description', '')[:500],
                    detailed_description=course_data.get('detailed_description', ''),
                    instructor=instructor,
                    category=default_category,
                    price=course_data.get('price', 0),
                    duration_hours=course_data.get('duration_hours', 0),
                    is_published=course_data.get('is_published', True),
                    is_featured=course_data.get('is_featured', False),
                    order_index=course_data.get('order_index', 0),
                    created_at=timezone.make_aware(
                        datetime.fromisoformat(course_data['created_at'])
                    ) if course_data.get('created_at') else timezone.now()
                )
                
                created_count += 1
                
            except Exception as e:
                error_count += 1
                print(f"강의 마이그레이션 오류: {e}")
        
        print(f"강의 마이그레이션 완료: {created_count}개 생성, {error_count}건 오류")
    
    @transaction.atomic
    def migrate_lessons(self):
        """레슨 데이터 마이그레이션"""
        print("레슨 데이터 마이그레이션 시작...")
        
        lessons_data = self.load_json_data('lessons.json')
        
        created_sections = 0
        created_lessons = 0
        error_count = 0
        
        # 강의별로 그룹화
        lessons_by_course = {}
        for lesson_data in lessons_data:
            course_id = lesson_data['course_id']
            if course_id not in lessons_by_course:
                lessons_by_course[course_id] = []
            lessons_by_course[course_id].append(lesson_data)
        
        for course_id, course_lessons in lessons_by_course.items():
            try:
                # 해당하는 Django 강의 찾기 (ASP ID 매핑 필요)
                course = Course.objects.filter(id=course_id).first()
                if not course:
                    print(f"강의를 찾을 수 없음: {course_id}")
                    continue
                
                # 기본 섹션 생성
                section, created = CourseSection.objects.get_or_create(
                    course=course,
                    order_index=1,
                    defaults={
                        'title': '기본 섹션',
                        'description': '마이그레이션된 기본 섹션'
                    }
                )
                
                if created:
                    created_sections += 1
                
                # 레슨들 생성
                for lesson_data in course_lessons:
                    Lesson.objects.create(
                        section=section,
                        title=lesson_data['title'][:255],
                        description=lesson_data.get('description', ''),
                        content_type=lesson_data.get('content_type', 'video'),
                        video_url=lesson_data.get('video_url', ''),
                        video_duration=lesson_data.get('duration_seconds', 0),
                        order_index=lesson_data.get('order_index', 1),
                        is_free=lesson_data.get('is_free', False)
                    )
                    created_lessons += 1
                    
            except Exception as e:
                error_count += 1
                print(f"레슨 마이그레이션 오류: {e}")
        
        print(f"레슨 마이그레이션 완료: 섹션 {created_sections}개, 레슨 {created_lessons}개 생성, {error_count}건 오류")
    
    @transaction.atomic
    def migrate_orders_and_enrollments(self):
        """주문 및 수강신청 마이그레이션"""
        print("주문/수강신청 데이터 마이그레이션 시작...")
        
        orders_data = self.load_json_data('orders.json')
        
        created_orders = 0
        created_enrollments = 0
        error_count = 0
        
        for order_data in orders_data:
            try:
                # 사용자 찾기
                user = User.objects.filter(
                    username=order_data['user_username']
                ).first()
                
                if not user:
                    print(f"사용자를 찾을 수 없음: {order_data['user_username']}")
                    continue
                
                # 강의 찾기
                course = Course.objects.filter(
                    id=order_data['course_id']
                ).first()
                
                if not course:
                    print(f"강의를 찾을 수 없음: {order_data['course_id']}")
                    continue
                
                # 주문 생성
                order = Order.objects.create(
                    order_number=order_data['order_number'],
                    user=user,
                    total_amount=order_data['amount'],
                    final_amount=order_data['amount'],
                    status='paid',
                    payment_method='card' if order_data['amount'] > 0 else 'free',
                    created_at=timezone.make_aware(
                        datetime.fromisoformat(order_data['payment_date'])
                    ) if order_data.get('payment_date') else timezone.now(),
                    paid_at=timezone.make_aware(
                        datetime.fromisoformat(order_data['payment_date'])
                    ) if order_data.get('payment_date') else timezone.now()
                )
                
                # 주문 항목 생성
                OrderItem.objects.create(
                    order=order,
                    course=course,
                    price=order_data['amount']
                )
                
                created_orders += 1
                
                # 수강신청 생성
                enrollment_status = self.map_enrollment_status(order_data['status'])
                
                enrollment = Enrollment.objects.create(
                    user=user,
                    course=course,
                    enrollment_date=timezone.make_aware(
                        datetime.fromisoformat(order_data['enrollment_start'])
                    ) if order_data.get('enrollment_start') else timezone.now(),
                    expiry_date=timezone.make_aware(
                        datetime.fromisoformat(order_data['enrollment_end'])
                    ) if order_data.get('enrollment_end') else None,
                    status=enrollment_status
                )
                
                created_enrollments += 1
                
            except Exception as e:
                error_count += 1
                print(f"주문/수강신청 마이그레이션 오류: {e}")
        
        print(f"주문/수강신청 마이그레이션 완료: 주문 {created_orders}개, 수강신청 {created_enrollments}개 생성, {error_count}건 오류")
    
    def map_enrollment_status(self, old_status):
        """수강신청 상태 매핑"""
        status_mapping = {
            'active': 'active',
            'expired': 'expired',
            'suspended': 'suspended'
        }
        return status_mapping.get(old_status, 'active')
    
    def parse_birth_date(self, birth_year):
        """생년월일 파싱"""
        if birth_year:
            try:
                return datetime(birth_year, 1, 1).date()
            except:
                pass
        return None
    
    def run_full_migration(self):
        """전체 마이그레이션 실행"""
        print("=== LMS 데이터 마이그레이션 시작 ===")
        
        try:
            self.migrate_users()
            self.migrate_courses()
            self.migrate_lessons()
            self.migrate_orders_and_enrollments()
            
            print("=== 모든 데이터 마이그레이션 완료 ===")
            
        except Exception as e:
            print(f"마이그레이션 중 오류 발생: {e}")
            raise

def main():
    migrator = DataMigrator()
    migrator.run_full_migration()

if __name__ == "__main__":
    main()
```

## 5. 데이터 검증 스크립트

```python
# scripts/validate_migration.py
import json
import os
import django
from datetime import datetime
from django.db.models import Count

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings.production')
django.setup()

from django.contrib.auth import get_user_model
from courses.models import Course, CourseSection, Lesson
from enrollments.models import Enrollment
from payments.models import Order

User = get_user_model()

class MigrationValidator:
    def __init__(self, data_dir='migration_data'):
        self.data_dir = data_dir
        self.validation_results = {}
        
    def load_json_data(self, filename):
        """JSON 파일에서 데이터 로드"""
        filepath = os.path.join(self.data_dir, filename)
        with open(filepath, 'r', encoding='utf-8') as f:
            return json.load(f)
    
    def validate_users(self):
        """사용자 데이터 검증"""
        print("사용자 데이터 검증 중...")
        
        original_users = self.load_json_data('users.json')
        migrated_count = User.objects.count()
        
        # 기본 통계
        results = {
            'original_count': len(original_users),
            'migrated_count': migrated_count,
            'success_rate': (migrated_count / len(original_users)) * 100 if original_users else 0
        }
        
        # 역할별 분포 확인
        role_distribution = User.objects.values('role').annotate(count=Count('role'))
        results['role_distribution'] = {item['role']: item['count'] for item in role_distribution}
        
        # 샘플 사용자 검증
        sample_validation = []
        for user_data in original_users[:10]:  # 처음 10명만 샘플 체크
            try:
                migrated_user = User.objects.get(username=user_data['username'])
                validation = {
                    'username': user_data['username'],
                    'email_match': migrated_user.email == user_data['email'],
                    'role_match': migrated_user.role == user_data['role'],
                    'is_valid': True
                }
            except User.DoesNotExist:
                validation = {
                    'username': user_data['username'],
                    'is_valid': False,
                    'error': 'User not found'
                }
            
            sample_validation.append(validation)
        
        results['sample_validation'] = sample_validation
        self.validation_results['users'] = results
        
        print(f"사용자 검증 완료: {results['success_rate']:.1f}% 성공")
    
    def validate_courses(self):
        """강의 데이터 검증"""
        print("강의 데이터 검증 중...")
        
        original_courses = self.load_json_data('courses.json')
        migrated_count = Course.objects.count()
        
        results = {
            'original_count': len(original_courses),
            'migrated_count': migrated_count,
            'success_rate': (migrated_count / len(original_courses)) * 100 if original_courses else 0
        }
        
        # 가격 분포 확인
        price_stats = Course.objects.aggregate(
            avg_price=models.Avg('price'),
            min_price=models.Min('price'),
            max_price=models.Max('price')
        )
        results['price_statistics'] = price_stats
        
        # 무료/유료 강의 분포
        free_count = Course.objects.filter(price=0).count()
        paid_count = Course.objects.filter(price__gt=0).count()
        results['pricing_distribution'] = {
            'free_courses': free_count,
            'paid_courses': paid_count
        }
        
        self.validation_results['courses'] = results
        
        print(f"강의 검증 완료: {results['success_rate']:.1f}% 성공")
    
    def validate_lessons(self):
        """레슨 데이터 검증"""
        print("레슨 데이터 검증 중...")
        
        original_lessons = self.load_json_data('lessons.json')
        migrated_sections = CourseSection.objects.count()
        migrated_lessons = Lesson.objects.count()
        
        results = {
            'original_lesson_count': len(original_lessons),
            'migrated_section_count': migrated_sections,
            'migrated_lesson_count': migrated_lessons,
            'lesson_success_rate': (migrated_lessons / len(original_lessons)) * 100 if original_lessons else 0
        }
        
        # 레슨 타입 분포
        content_type_distribution = Lesson.objects.values('content_type').annotate(count=Count('content_type'))
        results['content_type_distribution'] = {item['content_type']: item['count'] for item in content_type_distribution}
        
        # 비디오 시간 통계
        video_lessons = Lesson.objects.filter(content_type='video', video_duration__gt=0)
        if video_lessons.exists():
            from django.db.models import Avg, Sum
            duration_stats = video_lessons.aggregate(
                avg_duration=Avg('video_duration'),
                total_duration=Sum('video_duration'),
                count=Count('id')
            )
            results['video_statistics'] = duration_stats
        
        self.validation_results['lessons'] = results
        
        print(f"레슨 검증 완료: {results['lesson_success_rate']:.1f}% 성공")
    
    def validate_enrollments(self):
        """수강신청 데이터 검증"""
        print("수강신청 데이터 검증 중...")
        
        original_orders = self.load_json_data('orders.json')
        migrated_orders = Order.objects.count()
        migrated_enrollments = Enrollment.objects.count()
        
        results = {
            'original_order_count': len(original_orders),
            'migrated_order_count': migrated_orders,
            'migrated_enrollment_count': migrated_enrollments,
            'order_success_rate': (migrated_orders / len(original_orders)) * 100 if original_orders else 0
        }
        
        # 수강신청 상태 분포
        enrollment_status_distribution = Enrollment.objects.values('status').annotate(count=Count('status'))
        results['enrollment_status_distribution'] = {item['status']: item['count'] for item in enrollment_status_distribution}
        
        # 주문 상태 분포
        order_status_distribution = Order.objects.values('status').annotate(count=Count('status'))
        results['order_status_distribution'] = {item['status']: item['count'] for item in order_status_distribution}
        
        self.validation_results['enrollments'] = results
        
        print(f"수강신청 검증 완료: {results['order_success_rate']:.1f}% 성공")
    
    def validate_data_integrity(self):
        """데이터 무결성 검증"""
        print("데이터 무결성 검증 중...")
        
        integrity_issues = []
        
        # 1. 강의에 강사가 없는 경우
        courses_without_instructor = Course.objects.filter(instructor__isnull=True).count()
        if courses_without_instructor > 0:
            integrity_issues.append(f"강사가 없는 강의: {courses_without_instructor}개")
        
        # 2. 섹션이 없는 강의
        courses_without_sections = Course.objects.filter(sections__isnull=True).count()
        if courses_without_sections > 0:
            integrity_issues.append(f"섹션이 없는 강의: {courses_without_sections}개")
        
        # 3. 레슨이 없는 섹션
        sections_without_lessons = CourseSection.objects.filter(lessons__isnull=True).count()
        if sections_without_lessons > 0:
            integrity_issues.append(f"레슨이 없는 섹션: {sections_without_lessons}개")
        
        # 4. 사용자가 없는 수강신청
        enrollments_without_user = Enrollment.objects.filter(user__isnull=True).count()
        if enrollments_without_user > 0:
            integrity_issues.append(f"사용자가 없는 수강신청: {enrollments_without_user}개")
        
        # 5. 강의가 없는 수강신청
        enrollments_without_course = Enrollment.objects.filter(course__isnull=True).count()
        if enrollments_without_course > 0:
            integrity_issues.append(f"강의가 없는 수강신청: {enrollments_without_course}개")
        
        results = {
            'total_issues': len(integrity_issues),
            'issues': integrity_issues,
            'is_valid': len(integrity_issues) == 0
        }
        
        self.validation_results['data_integrity'] = results
        
        if integrity_issues:
            print(f"데이터 무결성 문제 발견: {len(integrity_issues)}건")
            for issue in integrity_issues:
                print(f"  - {issue}")
        else:
            print("데이터 무결성 검증 통과")
    
    def generate_report(self):
        """검증 보고서 생성"""
        report = {
            'validation_date': datetime.now().isoformat(),
            'results': self.validation_results,
            'summary': {
                'total_users': self.validation_results.get('users', {}).get('migrated_count', 0),
                'total_courses': self.validation_results.get('courses', {}).get('migrated_count', 0),
                'total_lessons': self.validation_results.get('lessons', {}).get('migrated_lesson_count', 0),
                'total_enrollments': self.validation_results.get('enrollments', {}).get('migrated_enrollment_count', 0),
                'data_integrity_valid': self.validation_results.get('data_integrity', {}).get('is_valid', False)
            }
        }
        
        # 보고서 저장
        with open('migration_validation_report.json', 'w', encoding='utf-8') as f:
            json.dump(report, f, ensure_ascii=False, indent=2, default=str)
        
        print("검증 보고서 생성 완료: migration_validation_report.json")
        
        return report
    
    def run_full_validation(self):
        """전체 검증 실행"""
        print("=== 마이그레이션 데이터 검증 시작 ===")
        
        self.validate_users()
        self.validate_courses()
        self.validate_lessons()
        self.validate_enrollments()
        self.validate_data_integrity()
        
        report = self.generate_report()
        
        print("=== 마이그레이션 데이터 검증 완료 ===")
        
        return report

def main():
    validator = MigrationValidator()
    report = validator.run_full_validation()
    
    # 요약 출력
    print("\n=== 검증 요약 ===")
    print(f"사용자: {report['summary']['total_users']}명")
    print(f"강의: {report['summary']['total_courses']}개")
    print(f"레슨: {report['summary']['total_lessons']}개")
    print(f"수강신청: {report['summary']['total_enrollments']}건")
    print(f"데이터 무결성: {'통과' if report['summary']['data_integrity_valid'] else '문제 있음'}")

if __name__ == "__main__":
    main()
```

이 마이그레이션 계획은 기존 ASP 시스템의 데이터를 안전하고 체계적으로 새 Django 시스템으로 이전하는 전체 프로세스를 포함합니다. 데이터 추출부터 검증까지의 모든 단계가 자동화되어 있어 효율적이고 신뢰할 수 있는 마이그레이션을 보장합니다.