#!/bin/bash

# 前进ERP - 自动部署脚本
# 检测SSH密钥配置并自动推送到GitHub

echo "🚀 前进ERP自动部署脚本"
echo "=================================="
echo ""

cd ~/qianjin-erp-github

# 颜色输出
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 检测SSH连接
echo "🔍 检测GitHub SSH连接..."
for i in {1..30}; do
    if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
        echo -e "${GREEN}✅ SSH连接成功！${NC}"
        echo ""

        # 推送代码
        echo "📤 推送代码到GitHub..."
        if git push -u origin main 2>&1; then
            echo ""
            echo -e "${GREEN}✅✅✅ 代码推送成功！ ✅✅✅${NC}"
            echo ""
            echo "📊 推送统计："
            echo "   - 提交数量: $(git log --oneline | wc -l | tr -d ' ')"
            echo "   - 远程仓库: git@github.com:lidderbus/qianjin-erp.git"
            echo ""
            echo "🔄 GitHub Actions 工作流已触发！"
            echo ""
            echo "📋 下一步："
            echo "   1. 查看构建状态: https://github.com/lidderbus/qianjin-erp/actions"
            echo "   2. 等待2-3分钟构建完成"
            echo "   3. 启用GitHub Pages: https://github.com/lidderbus/qianjin-erp/settings/pages"
            echo "      - Source: Deploy from a branch"
            echo "      - Branch: gh-pages"
            echo "      - 点击 Save"
            echo "   4. 等待1-2分钟后访问："
            echo "      🌐 https://lidderbus.github.io/qianjin-erp/"
            echo ""
            echo -e "${GREEN}🎉 自动部署配置完成！${NC}"
            exit 0
        else
            echo -e "${RED}❌ 推送失败！${NC}"
            echo ""
            echo "可能的原因："
            echo "1. 仓库权限问题"
            echo "2. 网络连接问题"
            echo "3. Git配置问题"
            exit 1
        fi
    fi

    if [ $i -eq 1 ]; then
        echo -e "${YELLOW}⏳ 等待SSH密钥添加到GitHub...${NC}"
        echo ""
        echo "请在浏览器中完成以下步骤："
        echo "1. 在打开的页面点击 'New SSH key'"
        echo "2. Title: Mac - qianjin-erp"
        echo "3. Key: Cmd+V 粘贴（已在剪贴板）"
        echo "4. 点击 'Add SSH key'"
        echo ""
        echo "完成后，脚本会自动检测并推送..."
        echo ""
    fi

    echo -n "."
    sleep 2
done

echo ""
echo -e "${RED}❌ 超时：SSH连接未建立${NC}"
echo ""
echo "请手动添加SSH密钥："
echo "1. 访问: https://github.com/settings/keys"
echo "2. 点击 'New SSH key'"
echo "3. 粘贴公钥（已在剪贴板）"
echo "4. 完成后重新运行此脚本"
exit 1
