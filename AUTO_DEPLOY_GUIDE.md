# 🚀 自动部署指南

## 📋 已完成的配置

✅ **Git仓库配置**
- 远程仓库：`git@github.com:lidderbus/qianjin-erp.git`
- 本地commits：3个专业提交

✅ **GitHub Actions工作流**
- 文件位置：`.github/workflows/deploy.yml`
- 触发条件：每次推送到main分支
- 部署目标：GitHub Pages (gh-pages分支)

✅ **Vue配置优化**
- publicPath设置为 `/qianjin-erp/`（适配GitHub Pages）
- 生产环境构建优化

## 🔑 第一步：添加SSH密钥到GitHub

**你的SSH公钥已复制到剪贴板！**

### 操作步骤：

1. 打开浏览器访问：https://github.com/settings/keys
2. 点击右上角绿色按钮 `New SSH key`
3. 填写信息：
   - **Title**: `Mac - qianjin-erp` (或任意名称)
   - **Key**: 直接粘贴（Cmd+V，公钥已在剪贴板）
4. 点击 `Add SSH key`
5. 可能需要输入GitHub密码确认

### 验证SSH连接：

```bash
ssh -T git@github.com
```

成功会显示：`Hi lidderbus! You've successfully authenticated, but GitHub does not provide shell access.`

## 🚀 第二步：推送代码到GitHub

SSH密钥配置完成后，执行：

```bash
cd ~/qianjin-erp-github
git add .
git commit -m "chore: 配置GitHub Actions自动部署

🔧 配置内容:
- 添加GitHub Actions工作流
- 配置自动构建和部署到GitHub Pages
- 优化Vue.config.js适配GitHub Pages

🚀 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"

git push -u origin main
```

## 📦 第三步：启用GitHub Pages

推送成功后：

1. 访问仓库设置：https://github.com/lidderbus/qianjin-erp/settings/pages

2. 配置GitHub Pages：
   - **Source**: 选择 `Deploy from a branch`
   - **Branch**: 选择 `gh-pages` 分支
   - **Folder**: `/ (root)`
   - 点击 `Save`

3. 等待1-2分钟后，页面会显示：
   ```
   Your site is live at https://lidderbus.github.io/qianjin-erp/
   ```

## 🔄 自动部署流程

配置完成后，每次你：

1. 修改代码
2. 提交到本地仓库：`git commit -m "更新描述"`
3. 推送到GitHub：`git push`

GitHub Actions会自动：
- ✅ 检出代码
- ✅ 安装依赖
- ✅ 构建Vue项目
- ✅ 部署到gh-pages分支
- ✅ 更新网站（1-2分钟生效）

## 📊 查看部署状态

访问：https://github.com/lidderbus/qianjin-erp/actions

可以看到：
- 🟢 构建成功（绿色对勾）
- 🔴 构建失败（红色叉）
- 🟡 构建中（黄色圆点）

## 🎯 访问部署的网站

部署成功后，访问：
**https://lidderbus.github.io/qianjin-erp/**

## 🔐 私密仓库说明

**重要**：你选择了私密仓库，这意味着：

✅ **代码私密**：只有你能看到源代码
✅ **GitHub Pages仍然公开**：部署的网站是公开的
❌ **免费账号限制**：GitHub免费账号的私密仓库可能无法使用GitHub Pages

### 解决方案：

**选项1：将仓库改为公开**（推荐）
```bash
# 访问设置
https://github.com/lidderbus/qianjin-erp/settings

# 滚动到底部 "Danger Zone"
# 点击 "Change visibility" -> "Change to public"
```

**选项2：使用其他部署方式**
- Vercel（支持私密仓库）
- Netlify（支持私密仓库）
- 自己的服务器

## 🛠️ Vercel部署（私密仓库友好）

如果想保持私密仓库：

```bash
# 安装Vercel CLI
npm install -g vercel

# 在项目目录执行
cd ~/qianjin-erp-github
vercel

# 按提示操作
```

访问：https://vercel.com/dashboard 查看部署状态

## ✅ 快速测试

推送代码后，等待2-3分钟，然后执行：

```bash
# 测试部署是否成功
curl -I https://lidderbus.github.io/qianjin-erp/
```

返回 `200 OK` 表示部署成功！

## 📝 常见问题

### Q1: GitHub Actions失败，显示权限错误

**解决**：
1. 访问：https://github.com/lidderbus/qianjin-erp/settings/actions
2. 找到 "Workflow permissions"
3. 选择 "Read and write permissions"
4. 保存并重新运行workflow

### Q2: 网站404错误

**检查**：
1. GitHub Pages是否启用了gh-pages分支
2. vue.config.js的publicPath是否正确设置为 `/qianjin-erp/`
3. 等待2-5分钟让GitHub Pages生效

### Q3: 私密仓库无法使用GitHub Pages

GitHub免费账号的私密仓库不支持GitHub Pages。

**解决方案**：
- 将仓库改为公开（代码本身也是开源的）
- 或使用Vercel/Netlify

## 🎉 部署完成检查清单

- [ ] SSH密钥已添加到GitHub
- [ ] 代码已推送到GitHub
- [ ] GitHub Actions构建成功（绿色对勾）
- [ ] GitHub Pages已启用
- [ ] 访问网站成功：https://lidderbus.github.io/qianjin-erp/
- [ ] 测试登录功能正常
- [ ] 测试模块导航正常

---

**现在开始第一步：添加SSH密钥到GitHub！** 🔑

公钥已在剪贴板，直接访问 https://github.com/settings/keys 添加即可。
