<template>
  <div class="login-container">
    <div class="login-card">
      <h1 class="gradient-title">前进ERP管理系统</h1>
      <p class="subtitle">Qianjin Gearbox ERP</p>

      <el-form :model="loginForm" :rules="rules" ref="loginForm" class="login-form">
        <el-form-item prop="username">
          <el-input
            v-model="loginForm.username"
            placeholder="用户名"
            prefix-icon="el-icon-user"
            size="large"
          />
        </el-form-item>
        <el-form-item prop="password">
          <el-input
            v-model="loginForm.password"
            type="password"
            placeholder="密码"
            prefix-icon="el-icon-lock"
            size="large"
            @keyup.enter.native="handleLogin"
          />
        </el-form-item>
        <el-form-item>
          <el-button
            type="primary"
            :loading="loading"
            @click="handleLogin"
            style="width: 100%;"
            size="large"
          >
            {{ loading ? '登录中...' : '登录' }}
          </el-button>
        </el-form-item>
      </el-form>

      <div class="demo-tip">
        <el-alert
          title="演示模式"
          type="info"
          description="任意用户名和密码即可登录体验"
          :closable="false"
        />
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Login',
  data() {
    return {
      loginForm: {
        username: '',
        password: ''
      },
      rules: {
        username: [
          { required: true, message: '请输入用户名', trigger: 'blur' }
        ],
        password: [
          { required: true, message: '请输入密码', trigger: 'blur' }
        ]
      },
      loading: false
    }
  },
  methods: {
    handleLogin() {
      this.$refs.loginForm.validate(valid => {
        if (valid) {
          this.loading = true

          // 模拟登录
          setTimeout(() => {
            const userInfo = {
              realName: this.loginForm.username || '演示用户',
              department: '技术部',
              position: '工程师'
            }

            this.$store.dispatch('login', userInfo)
            this.$message.success('登录成功！')
            this.loading = false
            this.$router.push('/')
          }, 1000)
        }
      })
    }
  }
}
</script>

<style scoped>
.login-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.login-card {
  width: 400px;
  background: white;
  border-radius: 15px;
  padding: 40px;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
}

.login-card h1 {
  text-align: center;
  font-size: 28px;
  margin-bottom: 10px;
}

.subtitle {
  text-align: center;
  color: #999;
  margin-bottom: 30px;
  font-size: 14px;
}

.login-form {
  margin-top: 30px;
}

.demo-tip {
  margin-top: 20px;
}
</style>
