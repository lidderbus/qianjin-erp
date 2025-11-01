# 推送代码到GitHub步骤

## 🔐 第一步：添加SSH密钥到GitHub（如果还没有）

### 你的SSH公钥：

```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILZxiKkBOPWO6EfQH4q8o4LsEpBVHukQCCeKwasTc8f7 lidderbus@github.com
```

### 添加步骤：

1. **复制上面的SSH公钥**（从 `ssh-ed25519` 到 `lidderbus@github.com`）

2. **访问GitHub添加SSH密钥**：
   - 打开：https://github.com/settings/keys
   - 点击 `New SSH key` 按钮
   - Title: 输入 `Mac - qianjin-erp`
   - Key: 粘贴上面的公钥
   - 点击 `Add SSH key`

3. **测试连接**：
   ```bash
   ssh -T git@github.com
   ```

   看到 `Hi lidderbus! You've successfully authenticated` 表示成功！

## 🚀 第二步：推送代码到GitHub

仓库已配置为：`git@github.com:lidderbus/qianjin-erp.git`

执行以下命令：

```bash
cd ~/qianjin-erp-github
git push -u origin main
```

## 📋 或者使用HTTPS方式（需要Personal Access Token）

如果不想使用SSH，可以使用HTTPS：

### 1. 创建Personal Access Token

1. 访问：https://github.com/settings/tokens
2. 点击 `Generate new token (classic)`
3. Note: 输入 `qianjin-erp-deploy`
4. 勾选权限：`repo` (全部)
5. 点击 `Generate token`
6. **复制token**（只显示一次！）

### 2. 切换为HTTPS并推送

```bash
cd ~/qianjin-erp-github

# 更改远程仓库为HTTPS
git remote remove origin
git remote add origin https://github.com/lidderbus/qianjin-erp.git

# 推送（会提示输入用户名和密码）
git push -u origin main
# Username: lidderbus
# Password: 粘贴你的Personal Access Token
```

## ✅ 验证推送成功

推送成功后，访问仓库查看：
https://github.com/lidderbus/qianjin-erp

你应该能看到：
- ✅ 3个commits
- ✅ 16个文件
- ✅ README.md正确显示

## 🎯 推送成功后的下一步

运行自动部署配置：
```bash
cd ~/qianjin-erp-github
# 我会帮你配置GitHub Actions自动部署
```

---

**选择一种方式完成推送后，告诉我，我会继续配置自动部署！** 🚀
