#!/bin/bash

# ERP 模块快速生成脚本
# 使用方法：bash scripts/generate-next-module.sh

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  🚀 ERP 模块快速生成助手"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📊 项目进度："
echo "  ✅ 已完成：1/38 个模块（客户管理）"
echo "  ⏳ 待生成：37 个模块"
echo "  📈 完成率：2.6%"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# 定义待生成模块列表（优先级排序）
modules=(
  "订单管理Pro|order-management|OrderManagement|订单跟踪分析，包含订单状态流转（待确认→已确认→生产中→已完成）、批量操作、数据导出|高"
  "报价管理|quote-management|QuoteManagement|智能报价系统，包含产品选择、价格计算、报价单生成和打印功能|高"
  "发票管理|invoice-management|InvoiceManagement|发票数据智能分析，包含发票录入、OCR识别、统计分析|高"
  "库存管理|inventory-management|InventoryManagement|配件库存管理，包含入库、出库、库存预警、库存盘点|高"
  "员工管理|employee-management|EmployeeManagement|员工信息维护，包含组织架构、权限管理、员工档案|高"
  "考勤打卡|attendance-checkin|AttendanceCheckin|快速上下班打卡，支持地理位置验证、人脸识别（预留）|中"
  "合同管理|contract-management|ContractManagement|合同信息维护，包含合同模板、电子签章（预留）、到期提醒|中"
  "会议纪要|meeting-minutes|MeetingMinutes|会议记录查询，支持富文本编辑、附件上传、参与人员管理|中"
  "销售业绩|sales-performance|SalesPerformance|销售业绩统计，多维度数据分析和图表展示（按人员、区域、产品）|中"
  "财务分析|financial-analysis|FinancialAnalysis|财务数据可视化，包含收入、支出、利润分析和趋势预测|中"
)

echo "📋 待生成模块列表（按优先级排序）："
echo ""

priority_high=0
priority_medium=0
priority_low=0

for i in "${!modules[@]}"; do
  IFS='|' read -r name route component desc priority <<< "${modules[$i]}"

  case $priority in
    "高")
      icon="🔴"
      ((priority_high++))
      ;;
    "中")
      icon="🟡"
      ((priority_medium++))
      ;;
    "低")
      icon="🟢"
      ((priority_low++))
      ;;
  esac

  printf "  %2d. %s %-15s [优先级: %s]\n" "$((i+1))" "$icon" "$name" "$priority"
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  🔴 高优先级：$priority_high 个"
echo "  🟡 中优先级：$priority_medium 个"
echo "  🟢 低优先级：$priority_low 个"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# 交互式选择
echo "请选择要生成的模块（输入序号）："
read -p "模块序号 [1-${#modules[@]}]: " module_index

if [[ ! $module_index =~ ^[0-9]+$ ]] || [ $module_index -lt 1 ] || [ $module_index -gt ${#modules[@]} ]; then
  echo "❌ 无效的模块序号"
  exit 1
fi

# 获取选中的模块信息
selected_module="${modules[$((module_index-1))]}"
IFS='|' read -r name route component desc priority <<< "$selected_module"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ✅ 已选择：$name"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📝 生成 Claude Code 提示词..."
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# 生成 Claude Code 提示词
cat <<EOF
生成 ${name} 模块

**基本要求**：
- 技术栈：Vue 2.7.16 + Element UI 2.15.14 + axios
- 参考模板：src/views/modules/CustomerManagement.vue
- 保持项目风格：紫色渐变主题 (#667eea → #764ba2)
- 文件路径：src/views/modules/${component}.vue
- 路由路径：/${route}
- 组件名称：${component}

**功能需求**：
${desc}

**必须包含的功能**：
1. ✅ 完整的 CRUD 操作（列表查询、新增、编辑、删除、查看详情）
2. ✅ 高级搜索和筛选（支持多条件组合搜索）
3. ✅ 分页功能（每页10/20/50/100条切换）
4. ✅ 表单验证（必填项、格式验证、自定义规则）
5. ✅ 开发环境模拟数据（至少3条示例数据）
6. ✅ 响应式布局（支持桌面和移动端）
7. ✅ 错误处理（网络错误、业务错误、表单验证错误）
8. ✅ 用户友好的提示信息（操作成功/失败提示）
9. ✅ 数据导出功能（预留接口）
10. ✅ 批量操作（选择框，预留批量删除接口）

**代码规范**：
- 使用 Vue 2 Options API（data, methods, computed, mounted等）
- 组件名称使用 PascalCase
- 方法名称使用 camelCase
- 样式使用 scoped
- 代码格式化：2空格缩进

**样式要求**：
- 页面背景：#f5f7fa
- 卡片背景：white
- 主色调：linear-gradient(135deg, #667eea 0%, #764ba2 100%)
- 圆角：border-radius: 8px
- 阴影：box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05)
- 按钮悬停效果：transform: translateY(-2px)

**API 接口规范**：
- 列表查询：GET /api/${route}?page=1&size=10
- 详情查询：GET /api/${route}/:id
- 新增：POST /api/${route}
- 更新：PUT /api/${route}/:id
- 删除：DELETE /api/${route}/:id

**输出要求**：
1. 生成完整的 Vue 单文件组件（template + script + style）
2. 添加路由配置到 src/router/index.js
3. 确保代码可以直接运行（包含模拟数据）

请开始生成代码。
EOF

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📋 使用方法："
echo "  1. 复制上方提示词（从 '生成' 到 '请开始生成代码'）"
echo "  2. 粘贴到 Claude Code 对话中"
echo "  3. 等待代码生成完成（约 3-5 分钟）"
echo "  4. 验证代码质量并进行必要的调整"
echo "  5. 运行 npm run serve 测试模块功能"
echo ""
echo "⏱️  预计耗时："
echo "  - 代码生成：5 分钟"
echo "  - 适配调整：30 分钟"
echo "  - 总计：35 分钟"
echo ""
echo "🎯 下一步："
echo "  1. 测试 ${name} 模块"
echo "  2. 集成后端 API"
echo "  3. 继续生成下一个模块"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
