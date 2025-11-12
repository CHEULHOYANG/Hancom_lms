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
  LinearProgress,
} from '@mui/material';
import {
  PlayArrow as PlayIcon,
  CheckCircle as CompleteIcon,
  Schedule as ScheduleIcon,
} from '@mui/icons-material';
import { useAuth } from '../contexts/AuthContext';
import axios from 'axios';

interface Course {
  id: number;
  title: string;
  description: string;
  instructor_name: string;
  duration_hours: number;
  level: string;
  thumbnail?: string;
  progress?: number;
  completed?: boolean;
}

const Dashboard: React.FC = () => {
  const { user } = useAuth();
  const [courses, setCourses] = useState<Course[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchMyCourses = async () => {
      try {
        const response = await axios.get('/enrollments/my-courses/');
        setCourses(response.data.results || response.data);
      } catch (error) {
        console.error('Failed to fetch courses:', error);
      } finally {
        setLoading(false);
      }
    };

    fetchMyCourses();
  }, []);

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
        안녕하세요, {user?.korean_name || user?.first_name}님! ?
      </Typography>
      
      <Typography variant="h6" color="text.secondary" gutterBottom sx={{ mb: 4 }}>
        오늘도 새로운 지식을 배워보세요
      </Typography>

      <Grid container spacing={3}>
        <Grid item xs={12} md={4}>
          <Card sx={{ background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)', color: 'white' }}>
            <CardContent>
              <Typography variant="h6" gutterBottom>
                내 진행 상황
              </Typography>
              <Typography variant="h3">
                {courses.filter(c => c.completed).length}
              </Typography>
              <Typography variant="body2">
                완료된 강의 / 총 {courses.length}개
              </Typography>
            </CardContent>
          </Card>
        </Grid>
        
        <Grid item xs={12} md={4}>
          <Card sx={{ background: 'linear-gradient(135deg, #11998e 0%, #38ef7d 100%)', color: 'white' }}>
            <CardContent>
              <Typography variant="h6" gutterBottom>
                학습 시간
              </Typography>
              <Typography variant="h3">
                {courses.reduce((total, course) => total + (course.duration_hours || 0), 0)}h
              </Typography>
              <Typography variant="body2">
                총 등록된 강의 시간
              </Typography>
            </CardContent>
          </Card>
        </Grid>
        
        <Grid item xs={12} md={4}>
          <Card sx={{ background: 'linear-gradient(135deg, #ff9a9e 0%, #fecfef 100%)', color: 'white' }}>
            <CardContent>
              <Typography variant="h6" gutterBottom>
                진행중인 강의
              </Typography>
              <Typography variant="h3">
                {courses.filter(c => !c.completed && (c.progress || 0) > 0).length}
              </Typography>
              <Typography variant="body2">
                현재 학습 중
              </Typography>
            </CardContent>
          </Card>
        </Grid>
      </Grid>

      <Typography variant="h5" sx={{ mt: 4, mb: 2 }}>
        내 강의
      </Typography>

      {loading ? (
        <LinearProgress />
      ) : courses.length === 0 ? (
        <Card>
          <CardContent sx={{ textAlign: 'center', py: 4 }}>
            <Typography variant="h6" color="text.secondary">
              등록된 강의가 없습니다
            </Typography>
            <Typography variant="body2" color="text.secondary" sx={{ mt: 1 }}>
              새로운 강의를 찾아 학습을 시작해보세요!
            </Typography>
            <Button
              variant="contained"
              sx={{ mt: 2 }}
              href="/courses"
            >
              강의 둘러보기
            </Button>
          </CardContent>
        </Card>
      ) : (
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
                  
                  {course.progress !== undefined && (
                    <Box>
                      <Box display="flex" justifyContent="space-between" mb={1}>
                        <Typography variant="body2" color="text.secondary">
                          진행률
                        </Typography>
                        <Typography variant="body2" color="text.secondary">
                          {Math.round(course.progress)}%
                        </Typography>
                      </Box>
                      <LinearProgress
                        variant="determinate"
                        value={course.progress}
                        sx={{ borderRadius: 1 }}
                      />
                    </Box>
                  )}
                </CardContent>
                
                <CardActions>
                  <Button
                    fullWidth
                    variant={course.completed ? "outlined" : "contained"}
                    startIcon={course.completed ? <CompleteIcon /> : <PlayIcon />}
                  >
                    {course.completed ? '완료됨' : '계속 학습'}
                  </Button>
                </CardActions>
              </Card>
            </Grid>
          ))}
        </Grid>
      )}
    </Box>
  );
};

export default Dashboard;