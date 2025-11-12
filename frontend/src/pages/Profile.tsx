import React, { useState } from 'react';
import {
  Typography,
  Grid,
  Card,
  CardContent,
  TextField,
  Button,
  Box,
  Avatar,
  Divider,
  Alert,
} from '@mui/material';
import { Edit as EditIcon, Save as SaveIcon } from '@mui/icons-material';
import { useAuth } from '../contexts/AuthContext';
import axios from 'axios';

const Profile: React.FC = () => {
  const { user, login } = useAuth();
  const [editing, setEditing] = useState(false);
  const [formData, setFormData] = useState({
    first_name: user?.first_name || '',
    last_name: user?.last_name || '',
    korean_name: user?.korean_name || '',
    phone_number: user?.phone_number || '',
    email: user?.email || '',
  });
  const [success, setSuccess] = useState('');
  const [error, setError] = useState('');

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value,
    });
  };

  const handleSave = async () => {
    try {
      await axios.put('/auth/profile/', formData);
      setSuccess('프로필이 성공적으로 업데이트되었습니다.');
      setError('');
      setEditing(false);
      
      // 사용자 정보 새로고침
      setTimeout(() => {
        window.location.reload();
      }, 1500);
    } catch (err: any) {
      setError('프로필 업데이트에 실패했습니다.');
      setSuccess('');
    }
  };

  const handleCancel = () => {
    setFormData({
      first_name: user?.first_name || '',
      last_name: user?.last_name || '',
      korean_name: user?.korean_name || '',
      phone_number: user?.phone_number || '',
      email: user?.email || '',
    });
    setEditing(false);
    setError('');
    setSuccess('');
  };

  return (
    <Box>
      <Typography variant="h4" gutterBottom>
        내 프로필
      </Typography>

      <Grid container spacing={3}>
        <Grid item xs={12} md={4}>
          <Card>
            <CardContent sx={{ textAlign: 'center', py: 4 }}>
              <Avatar
                sx={{
                  width: 120,
                  height: 120,
                  margin: '0 auto 2rem',
                  fontSize: '3rem',
                  background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
                }}
              >
                {(user?.korean_name || user?.first_name || 'U')[0]}
              </Avatar>
              
              <Typography variant="h5" gutterBottom>
                {user?.korean_name || `${user?.first_name} ${user?.last_name}`}
              </Typography>
              
              <Typography variant="body2" color="text.secondary">
                @{user?.username}
              </Typography>
              
              <Button
                variant={editing ? "outlined" : "contained"}
                startIcon={editing ? <SaveIcon /> : <EditIcon />}
                onClick={editing ? handleSave : () => setEditing(true)}
                sx={{ mt: 2 }}
              >
                {editing ? '저장' : '편집'}
              </Button>
              
              {editing && (
                <Button onClick={handleCancel} sx={{ mt: 1, ml: 1 }}>
                  취소
                </Button>
              )}
            </CardContent>
          </Card>
        </Grid>

        <Grid item xs={12} md={8}>
          <Card>
            <CardContent>
              <Typography variant="h6" gutterBottom>
                기본 정보
              </Typography>
              
              {success && (
                <Alert severity="success" sx={{ mb: 2 }}>
                  {success}
                </Alert>
              )}
              
              {error && (
                <Alert severity="error" sx={{ mb: 2 }}>
                  {error}
                </Alert>
              )}

              <Grid container spacing={2}>
                <Grid item xs={12} sm={6}>
                  <TextField
                    fullWidth
                    label="이름 (영문)"
                    name="first_name"
                    value={formData.first_name}
                    onChange={handleChange}
                    disabled={!editing}
                    margin="normal"
                  />
                </Grid>
                
                <Grid item xs={12} sm={6}>
                  <TextField
                    fullWidth
                    label="성 (영문)"
                    name="last_name"
                    value={formData.last_name}
                    onChange={handleChange}
                    disabled={!editing}
                    margin="normal"
                  />
                </Grid>
                
                <Grid item xs={12} sm={6}>
                  <TextField
                    fullWidth
                    label="한글 이름"
                    name="korean_name"
                    value={formData.korean_name}
                    onChange={handleChange}
                    disabled={!editing}
                    margin="normal"
                  />
                </Grid>
                
                <Grid item xs={12} sm={6}>
                  <TextField
                    fullWidth
                    label="전화번호"
                    name="phone_number"
                    value={formData.phone_number}
                    onChange={handleChange}
                    disabled={!editing}
                    margin="normal"
                  />
                </Grid>
                
                <Grid item xs={12}>
                  <TextField
                    fullWidth
                    label="이메일"
                    name="email"
                    type="email"
                    value={formData.email}
                    onChange={handleChange}
                    disabled={!editing}
                    margin="normal"
                  />
                </Grid>
              </Grid>
              
              <Divider sx={{ my: 3 }} />
              
              <Typography variant="h6" gutterBottom>
                계정 정보
              </Typography>
              
              <Grid container spacing={2}>
                <Grid item xs={12} sm={6}>
                  <TextField
                    fullWidth
                    label="사용자명"
                    value={user?.username}
                    disabled
                    margin="normal"
                  />
                </Grid>
                
                <Grid item xs={12} sm={6}>
                  <TextField
                    fullWidth
                    label="가입일"
                    value="2024-01-01" // 실제로는 user.date_joined를 사용
                    disabled
                    margin="normal"
                  />
                </Grid>
              </Grid>
            </CardContent>
          </Card>
        </Grid>
      </Grid>
    </Box>
  );
};

export default Profile;