#!/bin/bash

# 前进ERP系统 - 一键推送到GitHub脚本

echo "🚀 前进ERP系统 - GitHub推送脚本"
echo "=================================="
echo ""

# 检查是否在正确的目录
if [ ! -f "package.json" ]; then
    echo "❌ 错误：请在项目根目录执行此脚本"
    exit 1
fi

# 检查Git仓库
if [ ! -d ".git" ]; then
    echo "❌ 错误：未找到Git仓库"
    exit 1
fi

# 检查远程仓库
REMOTE=$(git remote get-url origin 2>/dev/null)
if [ -z "$REMOTE" ]; then
    echo "❌ 错误：未配置远程仓库"
    exit 1
fi

echo "📋 仓库信息："
echo "   远程地址: $REMOTE"
echo ""

# 测试SSH连接
echo "🔑 测试GitHub SSH连接..."
if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
    echo "✅ SSH连接成功！"
    echo ""
else
    echo "❌ SSH连接失败！"
    echo ""
    echo "请先添加SSH密钥到GitHub："
    echo "1. 复制公钥到剪贴板："
    cat ~/.ssh/id_ed25519.pub 2>/dev/null | pbcopy && echo "   ✅ 公钥已复制到剪贴板"
    echo ""
    echo "2. 访问 https://github.com/settings/keys"
    echo "3. 点击 'New SSH key'"
    echo "4. 粘贴公钥并保存"
    echo ""
    echo "完成后重新运行此脚本"
    exit 1
fi

# 显示待推送的提交
echo "📝 待推送的提交："
git log origin/main..HEAD --oneline 2>/dev/null || git log --oneline -n 5
echo ""

# 确认推送
read -p "是否推送到GitHub? (y/n) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ 取消推送"
    exit 1
fi

# 推送代码
echo ""
echo "🚀 推送代码到GitHub..."
if git push -u origin main; then
    echo ""
    echo "✅ 推送成功！"
    echo ""
    echo "📦 下一步："
    echo "1. 访问仓库：https://github.com/lidderbus/qianjin-erp"
    echo "2. 查看Actions：https://github.com/lidderbus/qianjin-erp/actions"
    echo "3. 启用GitHub Pages：https://github.com/lidderbus/qianjin-erp/settings/pages"
    echo "   - Source: Deploy from a branch"
    echo "   - Branch: gh-pages"
    echo "4. 等待2-3分钟后访问：https://lidderbus.github.io/qianjin-erp/"
    echo ""
    echo "🎉 完成！"
else
    echo ""
    echo "❌ 推送失败！"
    echo ""
    echo "请检查："
    echo "1. SSH密钥是否正确配置"
    echo "2. 网络连接是否正常"
    echo "3. 仓库权限是否正确"
    exit 1
fi
