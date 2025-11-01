/**
 * ERP系统模块配置
 */

export const categories = [
  { id: 'all', name: '全部', icon: 'el-icon-menu' },
  { id: 'core', name: '核心业务', icon: 'el-icon-star-on' },
  { id: 'sales', name: '销售管理', icon: 'el-icon-sell' },
  { id: 'finance', name: '财务管理', icon: 'el-icon-wallet' },
  { id: 'hr', name: '人力资源', icon: 'el-icon-user' },
  { id: 'product', name: '产品管理', icon: 'el-icon-goods' },
  { id: 'analysis', name: '数据分析', icon: 'el-icon-data-analysis' },
  { id: 'system', name: '系统管理', icon: 'el-icon-setting' }
]

export const modules = [
  // 核心业务 (13个)
  { name: '齿轮箱选型', desc: '智能选型配套方案', url: '/gearbox-selection-enhanced.html', icon: 'el-icon-setting', category: 'core', badge: 'NEW', badgeType: 'success' },
  { name: '工作总结', desc: '工作进展统计', url: '/work-summary-dashboard.html', icon: 'el-icon-document', category: 'core', badge: '热门', badgeType: 'danger' },
  { name: '发票管理', desc: '发票数据智能分析', url: '/gearbox-selection/invoice-management.html', icon: 'el-icon-tickets', category: 'core', badge: '新增', badgeType: 'success' },
  { name: '合同管理', desc: '合同信息维护', url: '/contract-management.html', icon: 'el-icon-document-checked', category: 'core' },
  { name: '配件销售', desc: '配件报价购物车', url: '/parts-sales-enhanced.html', icon: 'el-icon-sell', category: 'core', badge: '热门', badgeType: 'danger' },
  { name: '财务分析', desc: '财务数据可视化', url: '/financial-analysis.html', icon: 'el-icon-data-line', category: 'core' },
  { name: '技术支持', desc: '产品型号工程师查询', url: '/technical-support-best.html', icon: 'el-icon-service', category: 'core', badge: '91型号', badgeType: 'success' },
  { name: '项目跟踪', desc: '项目进度管理', url: '/project-tracking.html', icon: 'el-icon-finished', category: 'core' },
  { name: '配件库存', desc: '配件库存管理', url: '/inventory-all-parts.html', icon: 'el-icon-box', category: 'core' },
  { name: '配件库存Pro', desc: '智能库存分析系统', url: '/inventory-all-parts-pro.html', icon: 'el-icon-box', category: 'core', badge: '优化', badgeType: 'success' },
  { name: '绩效评估', desc: '员工绩效管理', url: '/performance-evaluation-real.html', icon: 'el-icon-trophy', category: 'core', badge: '真实', badgeType: 'success' },
  { name: '报价管理', desc: '智能报价系统', url: '/quote-management-enhanced.html', icon: 'el-icon-edit-outline', category: 'core', badge: '优化', badgeType: 'success' },
  { name: '销售业绩分析', desc: '多维度可视化数据洞察', url: '/sales-performance-enhanced.html', icon: 'el-icon-data-analysis', category: 'core', badge: '新增', badgeType: 'success' },

  // 销售管理 (6个)
  { name: '订单管理Pro', desc: '订单跟踪分析', url: '/order-management-enhanced.html', icon: 'el-icon-shopping-cart-2', category: 'sales', badge: '优化', badgeType: 'success' },
  { name: '会议纪要', desc: '会议记录查询', url: '/meeting-minutes.html', icon: 'el-icon-chat-dot-round', category: 'sales' },
  { name: '客户管理', desc: '客户信息维护', url: '/customer-management.html', icon: 'el-icon-user-solid', category: 'sales' },
  { name: '销售业绩', desc: '销售业绩统计', url: '/sales-performance.html', icon: 'el-icon-data-line', category: 'sales' },
  { name: '客户拜访', desc: '客户拜访管理', url: '/client-visit-management.html', icon: 'el-icon-place', category: 'sales' },
  { name: '交付管理', desc: '订单交付跟踪', url: '/delivery-management.html', icon: 'el-icon-truck', category: 'sales' },

  // 财务管理 (5个)
  { name: '发票管理Pro', desc: '发票查询统计', url: '/invoice-management-pro.html', icon: 'el-icon-tickets', category: 'finance', badge: '优化', badgeType: 'success' },
  { name: '应收管理Pro', desc: '应收账款智能管理', url: '/receivables-management-pro.html', icon: 'el-icon-wallet', category: 'finance', badge: '合并', badgeType: 'warning' },
  { name: '成本分析', desc: '成本统计分析', url: '/cost-analysis.html', icon: 'el-icon-data-analysis', category: 'finance' },
  { name: '预算管理', desc: '预算编制执行', url: '/budget-management.html', icon: 'el-icon-data-board', category: 'finance' },
  { name: '税务管理', desc: '税务申报管理', url: '/tax-management.html', icon: 'el-icon-document', category: 'finance' },

  // 人力资源 (4个)
  { name: '员工管理', desc: '员工信息维护', url: '/employee-management.html', icon: 'el-icon-user', category: 'hr' },
  { name: '考勤打卡', desc: '快速上下班打卡', url: '/attendance-checkin-db.html', icon: 'el-icon-time', category: 'hr', badge: '优化', badgeType: 'success' },
  { name: '考勤管理', desc: '考勤记录查询', url: '/attendance-management-lite.html', icon: 'el-icon-date', category: 'hr', badge: '优化', badgeType: 'success' },
  { name: '薪资管理', desc: '工资计算发放', url: '/salary-management.html', icon: 'el-icon-wallet', category: 'hr' },

  // 产品管理 (4个)
  { name: '产品目录', desc: '产品信息管理', url: '/product-catalog.html', icon: 'el-icon-folder-opened', category: 'product' },
  { name: '产品规格', desc: '产品规格说明', url: '/product-specifications.html', icon: 'el-icon-menu', category: 'product' },
  { name: '生产管理', desc: '生产计划管理', url: '/production-management.html', icon: 'el-icon-office-building', category: 'product' },
  { name: '质量控制', desc: '质量检验管理', url: '/quality-control.html', icon: 'el-icon-check', category: 'product' },

  // 数据分析 (5个)
  { name: '业务分析', desc: '业务数据分析', url: '/business-analysis.html', icon: 'el-icon-data-line', category: 'analysis' },
  { name: '客户分析', desc: '客户行为分析', url: '/customer-analysis.html', icon: 'el-icon-pie-chart', category: 'analysis' },
  { name: '经济分析', desc: '经济指标分析', url: '/economic-analysis.html', icon: 'el-icon-s-marketing', category: 'analysis' },
  { name: '数据中心', desc: '数据管理中心', url: '/data-management-center.html', icon: 'el-icon-coin', category: 'analysis' },
  { name: '报表中心', desc: '各类报表查询', url: '/report-center.html', icon: 'el-icon-document-copy', category: 'analysis' },

  // 系统管理 (4个)
  { name: '用户管理', desc: '用户权限管理', url: '/user-management.html', icon: 'el-icon-user', category: 'system' },
  { name: '系统设置', desc: '系统参数配置', url: '/system-settings.html', icon: 'el-icon-setting', category: 'system' },
  { name: '数据备份', desc: '数据备份恢复', url: '/data-backup.html', icon: 'el-icon-download', category: 'system' },
  { name: '操作日志', desc: '系统日志查询', url: '/system-logs.html', icon: 'el-icon-notebook-2', category: 'system' }
]

export const workflows = [
  {
    id: 'sales',
    name: '销售流程',
    steps: [
      { name: '客户拜访', url: '/client-visit-management.html' },
      { name: '报价管理', url: '/quote-management-enhanced.html' },
      { name: '合同管理', url: '/contract-management.html' },
      { name: '订单管理', url: '/order-management-enhanced.html' },
      { name: '交付管理', url: '/delivery-management.html' }
    ]
  },
  {
    id: 'finance',
    name: '财务流程',
    steps: [
      { name: '发票管理', url: '/invoice-management-pro.html' },
      { name: '应收管理', url: '/receivables-management-pro.html' },
      { name: '成本分析', url: '/cost-analysis.html' },
      { name: '财务分析', url: '/financial-analysis.html' }
    ]
  },
  {
    id: 'hr',
    name: '人力资源',
    steps: [
      { name: '员工管理', url: '/employee-management.html' },
      { name: '考勤打卡', url: '/attendance-checkin-db.html' },
      { name: '考勤管理', url: '/attendance-management-lite.html' },
      { name: '薪资管理', url: '/salary-management.html' },
      { name: '绩效评估', url: '/performance-evaluation-real.html' }
    ]
  }
]
