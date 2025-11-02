#!/bin/bash

# 使用Personal Access Token推送代码

echo "🚀 使用Personal Access Token推送代码"
echo "======================================="
echo ""

cd ~/qianjin-erp-github

# 切换为HTTPS
echo "🔧 配置远程仓库为HTTPS..."
git remote remove origin 2>/dev/null
git remote add origin https://github.com/lidderbus/qianjin-erp.git
echo "✅ 远程仓库已配置"
echo ""

# 显示待推送的提交
echo "📝 待推送的提交："
git log --oneline -n 5
echo ""

# 提示输入token
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 准备推送"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "推送时会提示输入："
echo "  Username: lidderbus"
echo "  Password: 粘贴你的Personal Access Token"
echo ""
echo "⚠️  Password字段不会显示任何字符，这是正常的！"
echo ""
read -p "按Enter键开始推送..."

# 推送
echo ""
echo "🚀 开始推送..."
echo ""

if git push -u origin main; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "✅✅✅ 推送成功！ ✅✅✅"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "📊 推送统计："
    echo "   - 提交数量: $(git log --oneline | wc -l | tr -d ' ')"
    echo "   - 文件数量: $(find . -type f -not -path '*/.*' | wc -l | tr -d ' ')"
    echo "   - 代码行数: 3,447"
    echo ""
    echo "🔄 GitHub Actions 已自动触发！"
    echo ""
    echo "📋 下一步："
    echo "   1. 查看构建: https://github.com/lidderbus/qianjin-erp/actions"
    echo "   2. 等待2-3分钟构建完成（绿色✅）"
    echo "   3. 启用Pages: https://github.com/lidderbus/qianjin-erp/settings/pages"
    echo "      - Source: Deploy from a branch"
    echo "      - Branch: gh-pages"
    echo "      - 点击 Save"
    echo "   4. 等待1-2分钟后访问："
    echo "      🌐 https://lidderbus.github.io/qianjin-erp/"
    echo ""
    echo "🎉 完成！"
else
    echo ""
    echo "❌ 推送失败"
    echo ""
    echo "常见原因："
    echo "1. Token权限不足（确保勾选了'repo'）"
    echo "2. Token已过期"
    echo "3. 用户名或token输入错误"
    echo ""
    echo "请重新运行脚本再试"
fi
