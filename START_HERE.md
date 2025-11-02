# 🚀 开始这里 - 自动部署ERP系统到GitHub

## ✅ 当前状态

**项目已完全准备就绪！**

- ✅ 完整的Vue.js项目结构
- ✅ 41个业务模块
- ✅ 完善的文档（中英文README）
- ✅ GitHub Actions自动部署配置
- ✅ 4个专业Git提交
- ✅ SSH公钥已复制到剪贴板

**等待完成：添加SSH密钥到GitHub → 推送代码 → 自动部署**

---

## 📋 三步完成部署

### 第1步：添加SSH密钥到GitHub（2分钟）

**公钥已在剪贴板中！** 直接粘贴即可。

1. **打开链接**：https://github.com/settings/keys

2. **点击绿色按钮**：`New SSH key`

3. **填写信息**：
   - Title: `Mac - qianjin-erp`
   - Key: **直接粘贴**（Cmd+V）

4. **点击**：`Add SSH key`

5. **可能需要输入GitHub密码确认**

**完成！** ✅

---

### 第2步：推送代码到GitHub（1分钟）

在终端执行：

```bash
cd ~/qianjin-erp-github
./push.sh
```

或者手动执行：

```bash
cd ~/qianjin-erp-github
git push -u origin main
```

推送成功后会看到：
```
✅ 推送成功！
```

---

### 第3步：启用GitHub Pages（2分钟）

#### 3.1 等待GitHub Actions构建完成

1. 访问：https://github.com/lidderbus/qianjin-erp/actions
2. 等待第一个workflow完成（约2-3分钟）
3. 看到绿色对勾 ✅ 表示构建成功

#### 3.2 启用GitHub Pages

**重要提示**：如果仓库是私密的，需要先改为公开

##### 方案A：将仓库改为公开（推荐）

1. 访问：https://github.com/lidderbus/qianjin-erp/settings
2. 滚动到最底部 "Danger Zone"
3. 点击 "Change visibility" → "Change to public"
4. 输入仓库名确认：`lidderbus/qianjin-erp`
5. 确认更改

##### 方案B：保持私密，使用Vercel部署

```bash
# 安装Vercel CLI
npm install -g vercel

# 部署
cd ~/qianjin-erp-github
vercel
```

#### 3.3 配置GitHub Pages（如果选择了方案A）

1. 访问：https://github.com/lidderbus/qianjin-erp/settings/pages

2. 配置：
   - **Source**: `Deploy from a branch`
   - **Branch**: `gh-pages`
   - **Folder**: `/ (root)`

3. 点击 **Save**

4. 等待1-2分钟，页面会显示：
   ```
   Your site is live at https://lidderbus.github.io/qianjin-erp/
   ```

---

## 🎉 完成！访问你的ERP系统

**网址**：https://lidderbus.github.io/qianjin-erp/

**测试功能**：
- 登录页面（任意用户名密码）
- 主面板
- 41个业务模块
- 统计卡片
- 业务流程导航

---

## 🔄 后续更新代码

每次更新代码后：

```bash
cd ~/qianjin-erp-github

# 修改代码...

git add .
git commit -m "描述你的更新"
git push

# GitHub Actions会自动重新部署！
```

---

## 📊 项目文件说明

| 文件 | 说明 |
|------|------|
| `START_HERE.md` | 👈 你正在看的文件 - 快速开始指南 |
| `AUTO_DEPLOY_GUIDE.md` | 详细的自动部署指南 |
| `PUSH_TO_GITHUB.md` | 推送代码详细步骤 |
| `DEPLOY.md` | 多种部署方式说明 |
| `README.md` | 项目中文文档 |
| `README_EN.md` | 项目英文文档 |
| `push.sh` | 一键推送脚本 |

---

## ❓ 常见问题

### Q: 推送时提示 "Permission denied (publickey)"

**解决**：SSH密钥未添加到GitHub
- 重新执行 `./push.sh`
- 按提示添加SSH密钥

### Q: GitHub Pages显示404

**原因**：
1. 仓库是私密的（免费账号不支持）
2. GitHub Pages未启用gh-pages分支

**解决**：
- 将仓库改为公开
- 或使用Vercel部署

### Q: 如何改为公开仓库？

访问：https://github.com/lidderbus/qianjin-erp/settings
滚动到底部 → "Change visibility" → "Change to public"

### Q: GitHub Actions失败了

**检查**：
1. https://github.com/lidderbus/qianjin-erp/actions 查看错误日志
2. 确认仓库有write权限
3. Settings → Actions → Workflow permissions → "Read and write permissions"

---

## 🎯 快速命令参考

```bash
# 推送代码
cd ~/qianjin-erp-github && ./push.sh

# 查看远程仓库
git remote -v

# 查看提交历史
git log --oneline

# 查看文件状态
git status

# 重新复制SSH公钥
cat ~/.ssh/id_ed25519.pub | pbcopy

# 测试SSH连接
ssh -T git@github.com
```

---

## 📞 需要帮助？

- 查看详细文档：`AUTO_DEPLOY_GUIDE.md`
- GitHub仓库：https://github.com/lidderbus/qianjin-erp
- 问题反馈：https://github.com/lidderbus/qianjin-erp/issues

---

**现在开始第1步：打开 https://github.com/settings/keys 添加SSH密钥！** 🔑

**公钥在剪贴板中，直接粘贴即可！**
