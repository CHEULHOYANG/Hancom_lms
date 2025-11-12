import React, { useState, useEffect } from 'react';
import {
  Typography,
  Grid,
  Card,
  CardContent,
  CardActions,
  Button,
  Box,
  Chip,
  Avatar,
  TextField,
  InputAdornment,
  FormControl,
  InputLabel,
  Select,
  MenuItem,
  Pagination,
} from '@mui/material';
import {
  Search as SearchIcon,
  Star as StarIcon,
  Schedule as ScheduleIcon,
} from '@mui/icons-material';
import axios from 'axios';

interface Course {
  id: number;
  title: string;
  description: string;
  instructor_name: string;
  duration_hours: number;
  level: string;
  price: number;
  thumbnail?: string;
  rating?: number;
  students_count?: number;
}

const Courses: React.FC = () => {
  const [courses, setCourses] = useState<Course[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const [levelFilter, setLevelFilter] = useState('');
  const [currentPage, setCurrentPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);

  useEffect(() => {
    fetchCourses();
  }, [currentPage, searchTerm, levelFilter]);

  const fetchCourses = async () => {
    try {
      setLoading(true);
      const params = new URLSearchParams();
      
      if (searchTerm) params.append('search', searchTerm);
      if (levelFilter) params.append('level', levelFilter);
      params.append('page', currentPage.toString());

      const response = await axios.get(`/courses/courses/?${params}`);
      setCourses(response.data.results || response.data);
      setTotalPages(Math.ceil((response.data.count || courses.length) / 12));
    } catch (error) {
      console.error('Failed to fetch courses:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleEnroll = async (courseId: number) => {
    try {
      await axios.post('/enrollments/enroll/', { course_id: courseId });
      alert('강의에 성공적으로 등록되었습니다!');
    } catch (error) {
      console.error('Failed to enroll:', error);
      alert('강의 등록에 실패했습니다.');
    }
  };

  const getLevelColor = (level: string) => {
    switch (level.toLowerCase()) {
      case 'beginner':
        return 'success';
      case 'intermediate':
        return 'warning';
      case 'advanced':
        return 'error';
      default:
        return 'default';
    }
  };

  return (
    <Box>
      <Typography variant="h4" gutterBottom>
        전체 강의
      </Typography>
      
      <Typography variant="body1" color="text.secondary" gutterBottom sx={{ mb: 3 }}>
        다양한 강의를 탐색하고 새로운 기술을 배워보세요
      </Typography>

      <Box sx={{ mb: 3 }}>
        <Grid container spacing={2} alignItems="center">
          <Grid item xs={12} md={6}>
            <TextField
              fullWidth
              placeholder="강의 검색..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              InputProps={{
                startAdornment: (
                  <InputAdornment position="start">
                    <SearchIcon />
                  </InputAdornment>
                ),
              }}
            />
          </Grid>
          
          <Grid item xs={12} md={3}>
            <FormControl fullWidth>
              <InputLabel>레벨</InputLabel>
              <Select
                value={levelFilter}
                label="레벨"
                onChange={(e) => setLevelFilter(e.target.value)}
              >
                <MenuItem value="">전체</MenuItem>
                <MenuItem value="beginner">초급</MenuItem>
                <MenuItem value="intermediate">중급</MenuItem>
                <MenuItem value="advanced">고급</MenuItem>
              </Select>
            </FormControl>
          </Grid>
          
          <Grid item xs={12} md={3}>
            <Button
              fullWidth
              variant="outlined"
              onClick={() => {
                setSearchTerm('');
                setLevelFilter('');
                setCurrentPage(1);
              }}
            >
              필터 초기화
            </Button>
          </Grid>
        </Grid>
      </Box>

      <Grid container spacing={3}>
        {courses.map((course) => (
          <Grid item xs={12} sm={6} md={4} key={course.id}>
            <Card sx={{ height: '100%', display: 'flex', flexDirection: 'column' }}>
              <CardContent sx={{ flexGrow: 1 }}>
                <Box display="flex" alignItems="center" mb={1}>
                  <Avatar sx={{ mr: 1, width: 24, height: 24 }}>
                    {course.instructor_name?.[0] || 'T'}
                  </Avatar>
                  <Typography variant="caption" color="text.secondary">
                    {course.instructor_name}
                  </Typography>
                </Box>
                
                <Typography variant="h6" gutterBottom>
                  {course.title}
                </Typography>
                
                <Typography variant="body2" color="text.secondary" sx={{ mb: 2 }}>
                  {course.description}
                </Typography>
                
                <Box display="flex" gap={1} mb={2}>
                  <Chip
                    label={course.level}
                    size="small"
                    color={getLevelColor(course.level) as any}
                  />
                  <Chip
                    icon={<ScheduleIcon />}
                    label={`${course.duration_hours}시간`}
                    size="small"
                    variant="outlined"
                  />
                </Box>
                
                <Box display="flex" justifyContent="space-between" alignItems="center">
                  <Typography variant="h6" color="primary">
                    {course.price === 0 ? '무료' : `?${course.price.toLocaleString()}`}
                  </Typography>
                  
                  {course.rating && (
                    <Box display="flex" alignItems="center">
                      <StarIcon sx={{ color: '#ffc107', mr: 0.5 }} fontSize="small" />
                      <Typography variant="body2">
                        {course.rating.toFixed(1)}
                      </Typography>
                    </Box>
                  )}
                </Box>
                
                {course.students_count && (
                  <Typography variant="caption" color="text.secondary">
                    {course.students_count}명이 수강 중
                  </Typography>
                )}
              </CardContent>
              
              <CardActions>
                <Button
                  fullWidth
                  variant="contained"
                  onClick={() => handleEnroll(course.id)}
                >
                  수강 신청
                </Button>
              </CardActions>
            </Card>
          </Grid>
        ))}
      </Grid>

      {courses.length === 0 && !loading && (
        <Card>
          <CardContent sx={{ textAlign: 'center', py: 4 }}>
            <Typography variant="h6" color="text.secondary">
              검색 결과가 없습니다
            </Typography>
            <Typography variant="body2" color="text.secondary" sx={{ mt: 1 }}>
              다른 검색어나 필터를 시도해보세요
            </Typography>
          </CardContent>
        </Card>
      )}

      {totalPages > 1 && (
        <Box display="flex" justifyContent="center" mt={4}>
          <Pagination
            count={totalPages}
            page={currentPage}
            onChange={(_, page) => setCurrentPage(page)}
            color="primary"
          />
        </Box>
      )}
    </Box>
  );
};

export default Courses;