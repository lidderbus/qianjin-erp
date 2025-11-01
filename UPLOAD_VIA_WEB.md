# 🌐 通过GitHub网页上传代码

## 方案说明

由于SSH配置较复杂，我已为你准备好可以直接上传的文件。

## 📦 已准备的文件

文件位置：`~/qianjin-erp-upload.tar.gz`

包含内容：
- 所有源代码
- GitHub Actions配置
- 完整文档
- 项目配置文件

## 🚀 上传步骤（5分钟）

### 方法1：GitHub网页上传（推荐，最简单）

1. **打开仓库页面**
   https://github.com/lidderbus/qianjin-erp

2. **上传文件**
   - 点击 `Add file` → `Upload files`
   - 将 `~/qianjin-erp-upload.tar.gz` 拖入页面
   - 或点击 `choose your files` 选择文件

3. **提交**
   - Commit message: `feat: 上传前进ERP系统完整代码`
   - 点击 `Commit changes`

### 方法2：通过Git网页编辑器

1. **访问**：https://github.com/lidderbus/qianjin-erp

2. **按 `.` 键**（会打开VS Code网页版）

3. **上传所有文件**
   - 拖拽项目文件到左侧文件树
   - 或使用上传按钮

4. **提交**
   - 填写commit message
   - 点击commit并push

### 方法3：GitHub Desktop（如果已安装）

1. **打开GitHub Desktop**

2. **Clone仓库**
   - File → Clone Repository
   - 选择 `lidderbus/qianjin-erp`

3. **复制文件**
   ```bash
   cp -r ~/qianjin-erp-github/* [克隆的目录]/
   ```

4. **提交推送**
   - 查看更改
   - 填写commit message
   - 点击 `Commit` 和 `Push`

## ⚡ 最快方式：使用临时Personal Access Token

### 步骤1：创建Token（2分钟）

1. 访问：https://github.com/settings/tokens
2. 点击 `Generate new token (classic)`
3. Note: `qianjin-erp-temp`
4. 勾选：`repo` (全部)
5. 点击 `Generate token`
6. **复制token**（只显示一次！）

### 步骤2：推送代码（1分钟）

在终端执行：

```bash
cd ~/qianjin-erp-github

# 更改为HTTPS方式
git remote remove origin
git remote add origin https://github.com/lidderbus/qianjin-erp.git

# 推送（会提示输入）
git push -u origin main
```

当提示输入时：
- Username: `lidderbus`
- Password: **粘贴你的Personal Access Token**

## 🎯 推送成功后

无论使用哪种方式，推送成功后：

1. **查看Actions**
   https://github.com/lidderbus/qianjin-erp/actions
   - 等待构建完成（2-3分钟）

2. **启用GitHub Pages**
   https://github.com/lidderbus/qianjin-erp/settings/pages
   - Source: `Deploy from a branch`
   - Branch: `gh-pages`
   - 点击 `Save`

3. **访问网站**（1-2分钟后）
   https://lidderbus.github.io/qianjin-erp/

## 💡 推荐方案

**最快最简单**：方法3（Personal Access Token）
- 只需创建一个临时token
- 2分钟内完成推送
- 用完可以删除token

**最直观**：方法1（网页上传）
- 不需要命令行
- 拖拽上传即可
- 适合不熟悉Git的用户

## 📋 需要的文件清单

项目中包含：
- ✅ 源代码（src/）
- ✅ 公共文件（public/）
- ✅ GitHub Actions（.github/workflows/）
- ✅ 配置文件（package.json, vue.config.js）
- ✅ 文档（README.md, DEPLOY.md等）
- ✅ Git忽略（.gitignore）

## ❓ 需要帮助？

选择你想使用的方式，我可以提供详细指导！
