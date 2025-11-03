import Vue from 'vue'
import VueRouter from 'vue-router'
import Dashboard from '../views/Dashboard.vue'

Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    name: 'Dashboard',
    component: Dashboard,
    meta: { title: '前进ERP管理系统' }
  },
  {
    path: '/login',
    name: 'Login',
    component: () => import('../views/Login.vue'),
    meta: { title: '登录' }
  },
  // 模块路由
  {
    path: '/customer-management',
    name: 'CustomerManagement',
    component: () => import('../views/modules/CustomerManagement.vue'),
    meta: { title: '客户管理', requiresAuth: true }
  },
  {
    path: '/quote-management',
    name: 'QuoteManagement',
    component: () => import('../views/modules/QuoteManagement.vue'),
    meta: { title: '报价管理', requiresAuth: true }
  }
]

const router = new VueRouter({
  mode: 'hash',
  base: process.env.BASE_URL,
  routes
})

router.beforeEach((to, from, next) => {
  document.title = to.meta.title || '前进ERP管理系统'
  next()
})

export default router
