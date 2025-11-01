# 部署指南

## 📦 本地开发部署

### 1. 克隆项目

```bash
git clone https://github.com/lidderbus/qianjin-erp.git
cd qianjin-erp
```

### 2. 安装依赖

```bash
npm install
# 或使用 yarn
yarn install
```

### 3. 启动开发服务器

```bash
npm run serve
```

访问 http://localhost:8080

## 🚀 生产环境部署

### 方法一：静态文件部署

1. **构建项目**

```bash
npm run build
```

2. **部署到服务器**

将 `dist/` 目录下的所有文件上传到Web服务器根目录。

#### Nginx配置示例

```nginx
server {
    listen 80;
    server_name your-domain.com;
    root /var/www/qianjin-erp/dist;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    # 开启gzip压缩
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
}
```

### 方法二：Docker部署

1. **创建Dockerfile**

```dockerfile
FROM node:14 AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

2. **构建并运行**

```bash
docker build -t qianjin-erp .
docker run -d -p 80:80 qianjin-erp
```

### 方法三：Vercel部署

1. 安装Vercel CLI

```bash
npm install -g vercel
```

2. 部署

```bash
vercel
```

### 方法四：GitHub Pages部署

1. 修改 `vue.config.js`

```javascript
module.exports = {
  publicPath: process.env.NODE_ENV === 'production'
    ? '/qianjin-erp/'  // 替换为你的仓库名
    : '/'
}
```

2. 构建并部署

```bash
npm run build
cd dist
git init
git add .
git commit -m "deploy"
git push -f git@github.com:lidderbus/qianjin-erp.git main:gh-pages
```

## 🔧 环境变量配置

创建 `.env` 文件配置环境变量：

```bash
# API基础URL
VUE_APP_API_BASE_URL=https://api.your-domain.com

# 应用标题
VUE_APP_TITLE=前进ERP管理系统

# 是否启用Mock数据
VUE_APP_USE_MOCK=true
```

## 📊 性能优化建议

### 1. 开启CDN加速

将Element UI等第三方库改为CDN引入：

```html
<!-- public/index.html -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/element-ui@2.15.14/lib/theme-chalk/index.css">
<script src="https://cdn.jsdelivr.net/npm/vue@2.7.16/dist/vue.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/element-ui@2.15.14/lib/index.js"></script>
```

### 2. 代码分割

利用Vue Router的懒加载：

```javascript
const Dashboard = () => import('./views/Dashboard.vue')
```

### 3. 图片优化

- 使用WebP格式
- 启用懒加载
- 压缩图片大小

### 4. 开启Gzip压缩

在服务器配置中启用Gzip。

## 🐛 故障排查

### 问题1：npm install 失败

```bash
# 清除缓存
npm cache clean --force
# 删除 node_modules 和 package-lock.json
rm -rf node_modules package-lock.json
# 重新安装
npm install
```

### 问题2：路由404错误

确保Web服务器配置了URL重写，将所有请求指向 `index.html`。

### 问题3：跨域问题

在 `vue.config.js` 中配置代理：

```javascript
module.exports = {
  devServer: {
    proxy: {
      '/api': {
        target: 'http://your-backend-url',
        changeOrigin: true
      }
    }
  }
}
```

## 📱 移动端适配

项目已经实现响应式布局，支持移动端访问。建议：

1. 测试不同屏幕尺寸
2. 优化触摸操作
3. 减少移动端加载的资源

## 🔐 安全建议

1. **HTTPS部署** - 使用SSL证书
2. **环境变量** - 不要在代码中硬编码敏感信息
3. **权限控制** - 实现完善的权限管理
4. **输入验证** - 前后端都要验证用户输入
5. **XSS防护** - 对用户输入进行转义

## 📞 技术支持

如遇部署问题，请：

1. 查看项目 [Issues](https://github.com/lidderbus/qianjin-erp/issues)
2. 提交新的Issue描述问题
3. 联系项目维护者

---

祝部署顺利！🎉
