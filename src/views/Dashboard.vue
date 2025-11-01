<template>
  <div class="dashboard-container">
    <!-- 顶部导航栏 -->
    <div class="header">
      <div class="header-left">
        <h1 class="gradient-title">前进ERP管理系统</h1>
        <p class="subtitle">Qianjin Gearbox Enterprise Resource Planning</p>
      </div>
      <div class="user-card">
        <div class="user-avatar">{{ userInitial }}</div>
        <div class="user-info">
          <div class="user-name">{{ userName }}</div>
          <div class="user-dept">{{ userDepartment }} - {{ userPosition }}</div>
        </div>
        <el-button size="small" @click="handleLogout">退出</el-button>
      </div>
    </div>

    <!-- 统计卡片 -->
    <div class="stats-grid">
      <div class="stat-card blue">
        <div class="icon"><i class="el-icon-document"></i></div>
        <div class="label">报价单</div>
        <div class="value">{{ stats.quotations }}</div>
      </div>
      <div class="stat-card green">
        <div class="icon"><i class="el-icon-shopping-cart-2"></i></div>
        <div class="label">订单</div>
        <div class="value">{{ stats.orders }}</div>
      </div>
      <div class="stat-card orange">
        <div class="icon"><i class="el-icon-user"></i></div>
        <div class="label">客户</div>
        <div class="value">{{ stats.customers }}</div>
      </div>
      <div class="stat-card red">
        <div class="icon"><i class="el-icon-time"></i></div>
        <div class="label">考勤</div>
        <div class="value">{{ stats.attendance }}</div>
      </div>
    </div>

    <!-- 最近访问 -->
    <div class="recent-section card" v-if="recentModules.length > 0">
      <h3><i class="el-icon-time"></i> 最近访问</h3>
      <div class="recent-modules">
        <el-tag
          v-for="module in recentModules"
          :key="module.url"
          @click="navigateToModule(module)"
          style="cursor: pointer; margin-right: 10px; margin-top: 10px;"
        >
          <i :class="module.icon"></i> {{ module.name }}
        </el-tag>
      </div>
    </div>

    <!-- 业务流程导航 -->
    <div class="workflow-section card">
      <h3><i class="el-icon-share"></i> 业务流程导航</h3>
      <el-tabs v-model="currentWorkflow">
        <el-tab-pane
          v-for="workflow in workflows"
          :key="workflow.id"
          :label="workflow.name"
          :name="workflow.id"
        >
          <div class="workflow-flow">
            <template v-for="(step, index) in workflow.steps">
              <el-button
                :key="step.url"
                type="primary"
                @click="navigateTo(step.url)"
              >
                {{ step.name }}
              </el-button>
              <i
                v-if="index < workflow.steps.length - 1"
                :key="'arrow-' + index"
                class="el-icon-right"
                style="margin: 0 10px; color: #999;"
              ></i>
            </template>
          </div>
        </el-tab-pane>
      </el-tabs>
    </div>

    <!-- 系统模块 -->
    <div class="modules-section card">
      <div class="section-header">
        <h3><i class="el-icon-menu"></i> 系统模块 ({{ filteredModules.length }}个)</h3>
        <el-input
          v-model="searchKeyword"
          placeholder="搜索模块..."
          prefix-icon="el-icon-search"
          style="width: 300px;"
          clearable
        />
      </div>

      <!-- 分类标签 -->
      <div class="category-tabs">
        <el-tag
          v-for="cat in categories"
          :key="cat.id"
          :type="currentCategory === cat.id ? 'primary' : 'info'"
          @click="currentCategory = cat.id"
          style="cursor: pointer; margin-right: 10px; margin-bottom: 10px;"
          effect="plain"
        >
          <i :class="cat.icon"></i> {{ cat.name }} ({{ getCategoryCount(cat.id) }})
        </el-tag>
      </div>

      <!-- 模块网格 -->
      <div class="modules-grid">
        <div
          v-for="module in filteredModules"
          :key="module.url"
          class="module-card"
          @click="navigateToModule(module)"
        >
          <div class="module-icon">
            <i :class="module.icon"></i>
          </div>
          <div class="module-name">{{ module.name }}</div>
          <div class="module-desc">{{ module.desc }}</div>
          <el-tag
            v-if="module.badge"
            :type="module.badgeType"
            size="mini"
            class="module-badge"
          >
            {{ module.badge }}
          </el-tag>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { categories, modules, workflows } from '@/utils/modules'

export default {
  name: 'Dashboard',
  data() {
    return {
      categories,
      modules,
      workflows,
      currentCategory: 'all',
      currentWorkflow: 'sales',
      searchKeyword: '',
      recentModules: []
    }
  },
  computed: {
    stats() {
      return this.$store.state.stats
    },
    userName() {
      return this.$store.getters.userName || '演示用户'
    },
    userDepartment() {
      return this.$store.getters.userDepartment || '技术部'
    },
    userPosition() {
      return this.$store.getters.userPosition || '工程师'
    },
    userInitial() {
      return this.userName ? this.userName[0] : 'U'
    },
    filteredModules() {
      let result = this.modules

      if (this.currentCategory !== 'all') {
        result = result.filter(m => m.category === this.currentCategory)
      }

      if (this.searchKeyword) {
        const keyword = this.searchKeyword.toLowerCase()
        result = result.filter(m =>
          m.name.toLowerCase().includes(keyword) ||
          m.desc.toLowerCase().includes(keyword)
        )
      }

      return result
    }
  },
  mounted() {
    this.checkAuth()
    this.loadRecentModules()
    this.fetchStats()
  },
  methods: {
    checkAuth() {
      const userInfo = localStorage.getItem('userInfo')
      if (!userInfo) {
        // 演示模式：使用默认用户信息
        const demoUser = {
          realName: '演示用户',
          department: '技术部',
          position: '工程师'
        }
        this.$store.dispatch('login', demoUser)
      }
    },
    async fetchStats() {
      // 演示数据
      const demoStats = {
        quotations: 12,
        orders: 25,
        customers: 20,
        attendance: 22
      }
      this.$store.dispatch('updateStats', demoStats)
    },
    loadRecentModules() {
      const recent = localStorage.getItem('recentModules')
      if (recent) {
        this.recentModules = JSON.parse(recent)
      }
    },
    saveRecentModules() {
      localStorage.setItem('recentModules', JSON.stringify(this.recentModules))
    },
    getCategoryCount(categoryId) {
      if (categoryId === 'all') return this.modules.length
      return this.modules.filter(m => m.category === categoryId).length
    },
    navigateToModule(module) {
      // 添加到最近访问
      const index = this.recentModules.findIndex(m => m.url === module.url)
      if (index > -1) {
        this.recentModules.splice(index, 1)
      }
      this.recentModules.unshift(module)
      if (this.recentModules.length > 8) {
        this.recentModules = this.recentModules.slice(0, 8)
      }
      this.saveRecentModules()

      this.$message.info(`功能开发中：${module.name}`)
      // window.location.href = module.url
    },
    navigateTo(url) {
      this.$message.info('功能开发中')
      // window.location.href = url
    },
    handleLogout() {
      this.$confirm('确定要退出系统吗?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.$store.dispatch('logout')
        this.$router.push('/login')
      }).catch(() => {})
    }
  }
}
</script>

<style scoped>
.dashboard-container {
  max-width: 1600px;
  margin: 0 auto;
}

.header {
  background: rgba(255, 255, 255, 0.95);
  border-radius: 15px;
  padding: 25px 35px;
  margin-bottom: 25px;
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12);
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.header-left h1 {
  font-size: 28px;
  margin-bottom: 8px;
}

.subtitle {
  color: #666;
  font-size: 14px;
}

.user-card {
  display: flex;
  align-items: center;
  gap: 12px;
}

.user-avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-weight: 600;
}

.user-name {
  font-weight: 600;
  color: #333;
}

.user-dept {
  font-size: 12px;
  color: #999;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 20px;
  margin-bottom: 25px;
}

.stat-card {
  background: white;
  border-radius: 12px;
  padding: 25px;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
  cursor: pointer;
  transition: all 0.3s;
}

.stat-card:hover {
  transform: translateY(-5px);
}

.stat-card .icon {
  width: 50px;
  height: 50px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 24px;
  color: white;
  margin-bottom: 15px;
}

.stat-card.blue .icon {
  background: linear-gradient(135deg, #667eea, #764ba2);
}

.stat-card.green .icon {
  background: linear-gradient(135deg, #06d6a0, #0ead69);
}

.stat-card.orange .icon {
  background: linear-gradient(135deg, #ff9a3c, #ff6a00);
}

.stat-card.red .icon {
  background: linear-gradient(135deg, #ef476f, #d32f2f);
}

.stat-card .label {
  color: #999;
  font-size: 14px;
  margin-bottom: 5px;
}

.stat-card .value {
  font-size: 32px;
  font-weight: 700;
  color: #333;
}

.recent-section h3,
.workflow-section h3,
.modules-section h3 {
  margin-bottom: 15px;
  color: #333;
}

.recent-modules {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.workflow-flow {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  padding: 15px 0;
  gap: 10px;
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  padding-bottom: 15px;
  border-bottom: 2px solid #f0f0f0;
}

.category-tabs {
  margin-bottom: 20px;
}

.modules-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
  gap: 20px;
}

.module-card {
  background: #f8f9fa;
  border-radius: 12px;
  padding: 20px;
  cursor: pointer;
  transition: all 0.3s;
  position: relative;
  text-align: center;
}

.module-card:hover {
  background: white;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
  transform: translateY(-5px);
}

.module-icon {
  width: 50px;
  height: 50px;
  margin: 0 auto 15px;
  border-radius: 50%;
  background: linear-gradient(135deg, #667eea, #764ba2);
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-size: 24px;
}

.module-name {
  font-weight: 600;
  color: #333;
  margin-bottom: 8px;
}

.module-desc {
  font-size: 12px;
  color: #999;
}

.module-badge {
  position: absolute;
  top: 10px;
  right: 10px;
}
</style>
