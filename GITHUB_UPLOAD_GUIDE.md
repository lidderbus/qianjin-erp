# GitHub上传指南

## 📋 前提条件

1. ✅ 已有GitHub账号：https://github.com/lidderbus
2. ✅ 本地Git仓库已初始化
3. ✅ 已完成代码提交

## 🚀 上传步骤

### 方法一：通过GitHub网页创建仓库（推荐）

#### 步骤1: 在GitHub上创建新仓库

1. 访问 https://github.com/new
2. 填写仓库信息：
   - **Repository name**: `qianjin-erp`
   - **Description**: `前进齿轮箱ERP管理系统 - 基于Vue.js和Element UI的企业资源规划系统`
   - **Visibility**: `Public` (推荐) 或 `Private`
   - **⚠️ 不要勾选** "Initialize this repository with a README"
3. 点击 "Create repository"

#### 步骤2: 连接本地仓库到GitHub

在项目目录执行：

```bash
cd ~/qianjin-erp-github

# 添加远程仓库
git remote add origin https://github.com/lidderbus/qianjin-erp.git

# 推送代码到GitHub
git push -u origin main
```

如果使用SSH方式：

```bash
git remote add origin git@github.com:lidderbus/qianjin-erp.git
git push -u origin main
```

### 方法二：使用GitHub CLI（需要先安装gh）

```bash
# 安装GitHub CLI (如果未安装)
brew install gh  # macOS
# 或访问 https://cli.github.com/ 下载

# 登录GitHub
gh auth login

# 创建仓库并推送
cd ~/qianjin-erp-github
gh repo create qianjin-erp --public --source=. --remote=origin --push
```

## 🔐 配置SSH密钥（推荐）

如果还没有配置SSH密钥：

### 1. 生成SSH密钥

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
# 按Enter使用默认路径，设置密码（可选）
```

### 2. 添加SSH密钥到GitHub

```bash
# 复制公钥到剪贴板
cat ~/.ssh/id_ed25519.pub | pbcopy  # macOS
# 或手动复制
cat ~/.ssh/id_ed25519.pub
```

1. 访问 https://github.com/settings/keys
2. 点击 "New SSH key"
3. 粘贴公钥
4. 点击 "Add SSH key"

### 3. 测试连接

```bash
ssh -T git@github.com
# 看到 "Hi username! You've successfully authenticated" 即成功
```

## 📝 推送后的操作

### 1. 验证仓库

访问 https://github.com/lidderbus/qianjin-erp 查看仓库

### 2. 添加仓库描述和标签

在GitHub仓库页面：

1. 点击右侧 "About" 旁边的齿轮图标
2. 添加描述：`前进齿轮箱ERP管理系统 - 基于Vue.js和Element UI的企业资源规划系统`
3. 添加网站（如有）
4. 添加主题标签：
   - `vue`
   - `element-ui`
   - `erp`
   - `erp-system`
   - `management-system`
   - `gearbox`
   - `enterprise`
   - `vuejs`
   - `javascript`

### 3. 设置GitHub Pages（可选）

1. 进入仓库 Settings > Pages
2. Source: 选择分支和目录
3. 保存后获得访问URL

### 4. 添加徽章（可选）

在README.md中已经包含了徽章，推送后会自动显示。

## 🔄 后续更新代码

```bash
# 修改代码后
git add .
git commit -m "描述你的改动"
git push
```

## ❓ 常见问题

### Q1: 推送时提示权限错误

**解决方案**:
```bash
# 检查远程仓库URL
git remote -v

# 如果是HTTPS方式，可能需要输入GitHub用户名和Personal Access Token
# 建议使用SSH方式
```

### Q2: 推送失败提示 "refusing to merge unrelated histories"

**解决方案**:
```bash
git pull origin main --allow-unrelated-histories
git push -u origin main
```

### Q3: 如何生成GitHub Personal Access Token

1. 访问 https://github.com/settings/tokens
2. 点击 "Generate new token (classic)"
3. 选择权限：`repo`
4. 生成并保存token（只显示一次）
5. 使用token代替密码

## 📊 推送检查清单

推送前确认：

- [ ] 已删除所有敏感信息（密钥、密码等）
- [ ] 已添加 .gitignore 文件
- [ ] README.md 文档完善
- [ ] LICENSE 文件已添加
- [ ] 提交信息清晰明确
- [ ] 项目可以正常运行

## 🎉 完成！

仓库地址: https://github.com/lidderbus/qianjin-erp

现在你可以：
- 分享你的项目
- 接受其他人的贡献
- 使用GitHub Actions进行CI/CD
- 创建Issues和Pull Requests

---

如有问题，请查看 [GitHub文档](https://docs.github.com/) 或提交Issue。
