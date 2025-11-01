# 前进齿轮箱ERP管理系统

<div align="center">

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![Vue](https://img.shields.io/badge/vue-2.7.16-brightgreen.svg)
![Element UI](https://img.shields.io/badge/element--ui-2.15.14-blue.svg)

一个功能完善的企业资源规划(ERP)管理系统，专为齿轮箱制造企业打造

[在线演示](#) | [快速开始](#快速开始) | [功能特性](#功能特性) | [技术栈](#技术栈)

</div>

---

## 📖 项目简介

前进ERP管理系统是一个基于Vue.js和Element UI开发的现代化企业资源规划系统，提供40+个业务模块，涵盖销售、财务、人力资源、生产、数据分析等核心业务流程。

### ✨ 核心亮点

- 🎯 **模块化设计** - 41个独立业务模块，灵活组合
- 🎨 **现代化UI** - 基于Element UI，渐变色设计，用户体验优秀
- 📊 **数据可视化** - 内置统计卡片、业务流程导航
- 🔐 **权限管理** - 完善的用户认证和权限控制
- 📱 **响应式布局** - 适配PC、平板、手机等多种设备
- 🚀 **高性能** - 优化加载速度，缓存机制

## 🚀 快速开始

### 环境要求

- Node.js >= 14.0.0
- npm >= 6.0.0

### 安装

```bash
# 克隆项目
git clone https://github.com/lidderbus/qianjin-erp.git

# 进入项目目录
cd qianjin-erp

# 安装依赖
npm install

# 启动开发服务器
npm run serve
```

### 构建生产版本

```bash
# 构建生产环境代码
npm run build
```

构建完成后，生成的文件位于 `dist/` 目录。

## 📦 功能特性

### 核心业务模块 (13个)

- ⚙️ **齿轮箱选型** - 智能选型配套方案
- 📝 **工作总结** - 工作进展统计
- 🧾 **发票管理** - 发票数据智能分析
- 📄 **合同管理** - 合同信息维护
- 🛒 **配件销售** - 配件报价购物车
- 💰 **财务分析** - 财务数据可视化
- 🎧 **技术支持** - 产品型号工程师查询
- 📊 **项目跟踪** - 项目进度管理
- 📦 **配件库存** - 配件库存管理
- 🏆 **绩效评估** - 员工绩效管理
- 💵 **报价管理** - 智能报价系统
- 📈 **销售业绩分析** - 多维度可视化数据洞察

### 销售管理 (6个)

- 订单管理Pro、会议纪要、客户管理
- 销售业绩、客户拜访、交付管理

### 财务管理 (5个)

- 发票管理Pro、应收管理Pro、成本分析
- 预算管理、税务管理

### 人力资源 (4个)

- 员工管理、考勤打卡、考勤管理、薪资管理

### 产品管理 (4个)

- 产品目录、产品规格、生产管理、质量控制

### 数据分析 (5个)

- 业务分析、客户分析、经济分析
- 数据中心、报表中心

### 系统管理 (4个)

- 用户管理、系统设置、数据备份、操作日志

## 🛠️ 技术栈

### 前端框架

- **Vue.js 2.7** - 渐进式JavaScript框架
- **Vue Router 3.6** - 官方路由管理器
- **Vuex 3.6** - 状态管理模式

### UI组件库

- **Element UI 2.15** - 基于Vue 2.0的桌面端组件库

### 工具库

- **Axios 1.6** - HTTP客户端

### 开发工具

- **Vue CLI 5.0** - Vue.js开发标准工具
- **webpack** - 模块打包器

## 📁 项目结构

```
qianjin-erp/
├── public/                # 静态资源
│   └── index.html        # HTML模板
├── src/
│   ├── assets/           # 资源文件
│   │   └── styles/       # 样式文件
│   │       └── global.css
│   ├── components/       # 公共组件
│   ├── router/           # 路由配置
│   │   └── index.js
│   ├── store/            # Vuex状态管理
│   │   └── index.js
│   ├── utils/            # 工具函数
│   │   └── modules.js    # 模块配置
│   ├── views/            # 页面组件
│   │   ├── Dashboard.vue # 主面板
│   │   └── Login.vue     # 登录页
│   ├── App.vue           # 根组件
│   └── main.js           # 入口文件
├── .gitignore            # Git忽略配置
├── package.json          # 项目配置
├── README.md             # 项目说明
└── LICENSE               # 开源协议
```

## 🎨 界面预览

### 主面板
- 顶部导航栏：系统标题、用户信息卡片
- 统计卡片：报价单、订单、客户、考勤数据
- 最近访问：快速访问最近使用的模块
- 业务流程导航：销售流程、财务流程、人力资源流程
- 系统模块网格：按分类展示所有业务模块

### 功能特色
- 🎨 渐变色设计，视觉效果现代化
- 🔍 模块搜索功能，快速定位
- 🏷️ 分类标签，便捷筛选
- 📌 最近访问记录，提升效率
- 🔄 业务流程导航，引导操作

## 📝 使用说明

### 登录系统

1. 访问系统登录页面
2. 输入任意用户名和密码（演示模式）
3. 点击登录按钮进入系统

### 导航使用

- **分类筛选**：点击分类标签筛选不同类型的模块
- **搜索功能**：输入关键词搜索模块名称或描述
- **最近访问**：快速访问最近使用的8个模块
- **业务流程**：按业务流程导航，提供完整的操作引导

### 模块访问

点击任意模块卡片即可进入对应的业务功能页面。

## 🔧 配置说明

### 模块配置

在 `src/utils/modules.js` 中可以配置：

- **categories**: 模块分类
- **modules**: 所有业务模块
- **workflows**: 业务流程

### 路由配置

在 `src/router/index.js` 中配置页面路由。

### 状态管理

在 `src/store/index.js` 中管理全局状态。

## 🤝 贡献指南

欢迎提交 Issue 和 Pull Request！

1. Fork 本项目
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

## 📄 开源协议

本项目基于 [MIT License](LICENSE) 开源协议。

## 👨‍💻 作者

**lidderbus**

- GitHub: [@lidderbus](https://github.com/lidderbus)

## 🙏 致谢

- [Vue.js](https://vuejs.org/)
- [Element UI](https://element.eleme.io/)
- 所有贡献者

---

<div align="center">

如果这个项目对你有帮助，欢迎 ⭐️ Star 支持！

</div>
