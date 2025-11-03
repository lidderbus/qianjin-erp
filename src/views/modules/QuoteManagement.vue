<template>
  <div class="quote-management">
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-left">
        <h2><i class="el-icon-document"></i> 报价管理</h2>
        <p>智能报价系统 - 快速生成专业报价单</p>
      </div>
      <div class="header-actions">
        <el-button type="primary" icon="el-icon-plus" @click="handleAdd">新增报价</el-button>
        <el-button type="success" icon="el-icon-download" @click="handleExport">导出数据</el-button>
      </div>
    </div>

    <!-- 搜索栏 -->
    <div class="search-bar">
      <el-form :inline="true" :model="searchForm" class="search-form">
        <el-form-item label="报价单号">
          <el-input
            v-model="searchForm.quoteNo"
            placeholder="请输入报价单号"
            clearable
            @clear="handleSearch"
          ></el-input>
        </el-form-item>
        <el-form-item label="客户名称">
          <el-input
            v-model="searchForm.customerName"
            placeholder="请输入客户名称"
            clearable
            @clear="handleSearch"
          ></el-input>
        </el-form-item>
        <el-form-item label="报价状态">
          <el-select v-model="searchForm.status" placeholder="请选择" clearable>
            <el-option label="全部" value=""></el-option>
            <el-option label="草稿" value="draft"></el-option>
            <el-option label="待审批" value="pending"></el-option>
            <el-option label="已审批" value="approved"></el-option>
            <el-option label="已拒绝" value="rejected"></el-option>
            <el-option label="已过期" value="expired"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="创建日期">
          <el-date-picker
            v-model="searchForm.dateRange"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            value-format="yyyy-MM-dd"
            clearable
          ></el-date-picker>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="el-icon-search" @click="handleSearch">搜索</el-button>
          <el-button icon="el-icon-refresh" @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>
    </div>

    <!-- 数据表格 -->
    <div class="table-container">
      <el-table
        :data="tableData"
        v-loading="loading"
        border
        stripe
        style="width: 100%"
        @selection-change="handleSelectionChange"
      >
        <el-table-column type="selection" width="55" align="center"></el-table-column>
        <el-table-column prop="quoteNo" label="报价单号" width="150" sortable fixed="left"></el-table-column>
        <el-table-column prop="customerName" label="客户名称" min-width="150" show-overflow-tooltip></el-table-column>
        <el-table-column prop="contactPerson" label="联系人" width="100"></el-table-column>
        <el-table-column prop="contactPhone" label="联系电话" width="130"></el-table-column>
        <el-table-column prop="totalAmount" label="报价金额" width="120" sortable>
          <template slot-scope="scope">
            <span class="amount-text">¥{{ formatAmount(scope.row.totalAmount) }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="validDays" label="有效期" width="100" align="center">
          <template slot-scope="scope">
            {{ scope.row.validDays }}天
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态" width="100" align="center">
          <template slot-scope="scope">
            <el-tag :type="getStatusType(scope.row.status)" size="small">
              {{ getStatusText(scope.row.status) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createUser" label="创建人" width="100"></el-table-column>
        <el-table-column prop="createTime" label="创建时间" width="160" sortable></el-table-column>
        <el-table-column label="操作" width="280" fixed="right" align="center">
          <template slot-scope="scope">
            <el-button type="text" icon="el-icon-view" @click="handleView(scope.row)">查看</el-button>
            <el-button type="text" icon="el-icon-edit" @click="handleEdit(scope.row)"
              v-if="scope.row.status === 'draft'">编辑</el-button>
            <el-button type="text" icon="el-icon-printer" @click="handlePrint(scope.row)">打印</el-button>
            <el-button type="text" icon="el-icon-s-order" @click="handleConvertToOrder(scope.row)"
              v-if="scope.row.status === 'approved'">转订单</el-button>
            <el-button type="text" icon="el-icon-delete" class="danger" @click="handleDelete(scope.row)"
              v-if="scope.row.status === 'draft'">删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <!-- 分页 -->
      <div class="pagination-container">
        <el-pagination
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
          :current-page="pagination.current"
          :page-sizes="[10, 20, 50, 100]"
          :page-size="pagination.size"
          layout="total, sizes, prev, pager, next, jumper"
          :total="pagination.total"
        ></el-pagination>
      </div>
    </div>

    <!-- 新增/编辑对话框 -->
    <el-dialog
      :title="dialogTitle"
      :visible.sync="dialogVisible"
      width="90%"
      top="5vh"
      :close-on-click-modal="false"
      @close="handleDialogClose"
    >
      <el-form :model="form" :rules="rules" ref="quoteForm" label-width="100px">
        <el-card class="form-card" shadow="never">
          <div slot="header" class="card-header">
            <span>基本信息</span>
          </div>
          <el-row :gutter="20">
            <el-col :span="8">
              <el-form-item label="报价单号" prop="quoteNo">
                <el-input v-model="form.quoteNo" disabled placeholder="系统自动生成"></el-input>
              </el-form-item>
            </el-col>
            <el-col :span="8">
              <el-form-item label="客户名称" prop="customerId">
                <el-select v-model="form.customerId" placeholder="请选择客户" filterable style="width: 100%"
                  @change="handleCustomerChange">
                  <el-option
                    v-for="customer in customerList"
                    :key="customer.id"
                    :label="customer.name"
                    :value="customer.id"
                  ></el-option>
                </el-select>
              </el-form-item>
            </el-col>
            <el-col :span="8">
              <el-form-item label="联系人" prop="contactPerson">
                <el-input v-model="form.contactPerson" placeholder="请输入联系人"></el-input>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row :gutter="20">
            <el-col :span="8">
              <el-form-item label="联系电话" prop="contactPhone">
                <el-input v-model="form.contactPhone" placeholder="请输入联系电话"></el-input>
              </el-form-item>
            </el-col>
            <el-col :span="8">
              <el-form-item label="有效期" prop="validDays">
                <el-input-number v-model="form.validDays" :min="1" :max="365" style="width: 100%"></el-input-number>
                <span style="margin-left: 10px; color: #909399;">天</span>
              </el-form-item>
            </el-col>
            <el-col :span="8">
              <el-form-item label="报价日期" prop="quoteDate">
                <el-date-picker
                  v-model="form.quoteDate"
                  type="date"
                  placeholder="选择日期"
                  value-format="yyyy-MM-dd"
                  style="width: 100%"
                ></el-date-picker>
              </el-form-item>
            </el-col>
          </el-row>
        </el-card>

        <el-card class="form-card" shadow="never" style="margin-top: 20px;">
          <div slot="header" class="card-header">
            <span>产品明细</span>
            <el-button type="primary" size="small" icon="el-icon-plus" @click="handleAddProduct">添加产品</el-button>
          </div>
          <el-table :data="form.products" border style="width: 100%">
            <el-table-column type="index" label="序号" width="60" align="center"></el-table-column>
            <el-table-column label="产品名称" min-width="150">
              <template slot-scope="scope">
                <el-select v-model="scope.row.productId" placeholder="请选择产品" filterable
                  @change="handleProductChange(scope.$index)">
                  <el-option
                    v-for="product in productList"
                    :key="product.id"
                    :label="product.name"
                    :value="product.id"
                  ></el-option>
                </el-select>
              </template>
            </el-table-column>
            <el-table-column prop="specification" label="规格型号" width="150">
              <template slot-scope="scope">
                <el-input v-model="scope.row.specification" placeholder="规格型号"></el-input>
              </template>
            </el-table-column>
            <el-table-column label="数量" width="120">
              <template slot-scope="scope">
                <el-input-number v-model="scope.row.quantity" :min="1" :precision="0"
                  @change="calculateRowAmount(scope.$index)" style="width: 100%"></el-input-number>
              </template>
            </el-table-column>
            <el-table-column label="单价（元）" width="150">
              <template slot-scope="scope">
                <el-input-number v-model="scope.row.unitPrice" :min="0" :precision="2"
                  @change="calculateRowAmount(scope.$index)" style="width: 100%"></el-input-number>
              </template>
            </el-table-column>
            <el-table-column label="折扣" width="100">
              <template slot-scope="scope">
                <el-input-number v-model="scope.row.discount" :min="0" :max="1" :step="0.1" :precision="2"
                  @change="calculateRowAmount(scope.$index)" style="width: 100%"></el-input-number>
              </template>
            </el-table-column>
            <el-table-column label="小计（元）" width="150">
              <template slot-scope="scope">
                <span class="amount-text">¥{{ formatAmount(scope.row.amount) }}</span>
              </template>
            </el-table-column>
            <el-table-column label="备注" min-width="150">
              <template slot-scope="scope">
                <el-input v-model="scope.row.remark" placeholder="备注"></el-input>
              </template>
            </el-table-column>
            <el-table-column label="操作" width="80" align="center">
              <template slot-scope="scope">
                <el-button type="text" icon="el-icon-delete" class="danger"
                  @click="handleRemoveProduct(scope.$index)">删除</el-button>
              </template>
            </el-table-column>
          </el-table>
          <div class="total-section">
            <el-row>
              <el-col :span="18" class="total-label">产品总金额：</el-col>
              <el-col :span="6" class="total-amount">¥{{ formatAmount(productTotalAmount) }}</el-col>
            </el-row>
            <el-row>
              <el-col :span="18" class="total-label">
                其他费用：
                <el-input-number v-model="form.otherFee" :min="0" :precision="2" size="small"
                  @change="calculateTotalAmount" style="width: 150px; margin-left: 10px;"></el-input-number>
              </el-col>
              <el-col :span="6" class="total-amount">¥{{ formatAmount(form.otherFee) }}</el-col>
            </el-row>
            <el-row>
              <el-col :span="18" class="total-label total-final">报价总金额：</el-col>
              <el-col :span="6" class="total-amount total-final">¥{{ formatAmount(form.totalAmount) }}</el-col>
            </el-row>
          </div>
        </el-card>

        <el-card class="form-card" shadow="never" style="margin-top: 20px;">
          <div slot="header" class="card-header">
            <span>其他信息</span>
          </div>
          <el-form-item label="备注说明">
            <el-input v-model="form.remark" type="textarea" :rows="3" placeholder="请输入备注说明"></el-input>
          </el-form-item>
          <el-form-item label="付款方式">
            <el-select v-model="form.paymentMethod" placeholder="请选择付款方式" style="width: 300px;">
              <el-option label="货到付款" value="cod"></el-option>
              <el-option label="预付30%" value="prepay30"></el-option>
              <el-option label="预付50%" value="prepay50"></el-option>
              <el-option label="月结30天" value="monthly30"></el-option>
              <el-option label="其他" value="other"></el-option>
            </el-select>
          </el-form-item>
          <el-form-item label="交货期限">
            <el-input v-model="form.deliveryTerm" placeholder="例如：收到订单后7个工作日内发货" style="width: 500px;"></el-input>
          </el-form-item>
        </el-card>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmit('draft')" :loading="submitLoading">保存草稿</el-button>
        <el-button type="success" @click="handleSubmit('pending')" :loading="submitLoading">提交审批</el-button>
      </div>
    </el-dialog>

    <!-- 查看详情对话框 -->
    <el-dialog title="报价单详情" :visible.sync="detailVisible" width="90%" top="5vh">
      <div class="detail-container" v-if="detailData.quoteNo">
        <el-card shadow="never">
          <div slot="header" class="detail-header">
            <h3>报价单：{{ detailData.quoteNo }}</h3>
            <el-tag :type="getStatusType(detailData.status)" size="medium">
              {{ getStatusText(detailData.status) }}
            </el-tag>
          </div>
          <el-descriptions :column="3" border>
            <el-descriptions-item label="客户名称">{{ detailData.customerName }}</el-descriptions-item>
            <el-descriptions-item label="联系人">{{ detailData.contactPerson }}</el-descriptions-item>
            <el-descriptions-item label="联系电话">{{ detailData.contactPhone }}</el-descriptions-item>
            <el-descriptions-item label="报价日期">{{ detailData.quoteDate }}</el-descriptions-item>
            <el-descriptions-item label="有效期">{{ detailData.validDays }}天</el-descriptions-item>
            <el-descriptions-item label="到期日期">{{ detailData.expiryDate }}</el-descriptions-item>
            <el-descriptions-item label="创建人">{{ detailData.createUser }}</el-descriptions-item>
            <el-descriptions-item label="创建时间">{{ detailData.createTime }}</el-descriptions-item>
            <el-descriptions-item label="更新时间">{{ detailData.updateTime }}</el-descriptions-item>
          </el-descriptions>
        </el-card>

        <el-card shadow="never" style="margin-top: 20px;">
          <div slot="header">产品明细</div>
          <el-table :data="detailData.products" border style="width: 100%">
            <el-table-column type="index" label="序号" width="60" align="center"></el-table-column>
            <el-table-column prop="productName" label="产品名称" min-width="150"></el-table-column>
            <el-table-column prop="specification" label="规格型号" width="150"></el-table-column>
            <el-table-column prop="quantity" label="数量" width="100" align="center"></el-table-column>
            <el-table-column prop="unitPrice" label="单价（元）" width="120" align="right">
              <template slot-scope="scope">
                ¥{{ formatAmount(scope.row.unitPrice) }}
              </template>
            </el-table-column>
            <el-table-column prop="discount" label="折扣" width="100" align="center"></el-table-column>
            <el-table-column prop="amount" label="小计（元）" width="150" align="right">
              <template slot-scope="scope">
                <span class="amount-text">¥{{ formatAmount(scope.row.amount) }}</span>
              </template>
            </el-table-column>
            <el-table-column prop="remark" label="备注" min-width="150"></el-table-column>
          </el-table>
          <div class="detail-total">
            <p>产品总金额：<span>¥{{ formatAmount(detailData.productTotal) }}</span></p>
            <p>其他费用：<span>¥{{ formatAmount(detailData.otherFee) }}</span></p>
            <p class="total-final">报价总金额：<span>¥{{ formatAmount(detailData.totalAmount) }}</span></p>
          </div>
        </el-card>

        <el-card shadow="never" style="margin-top: 20px;">
          <div slot="header">其他信息</div>
          <el-descriptions :column="2" border>
            <el-descriptions-item label="付款方式">{{ getPaymentMethodText(detailData.paymentMethod) }}</el-descriptions-item>
            <el-descriptions-item label="交货期限">{{ detailData.deliveryTerm || '无' }}</el-descriptions-item>
            <el-descriptions-item label="备注说明" :span="2">{{ detailData.remark || '无' }}</el-descriptions-item>
          </el-descriptions>
        </el-card>
      </div>
      <div slot="footer" class="dialog-footer">
        <el-button @click="detailVisible = false">关闭</el-button>
        <el-button type="primary" icon="el-icon-printer" @click="handlePrint(detailData)">打印</el-button>
        <el-button type="primary" v-if="detailData.status === 'draft'" @click="handleEdit(detailData)">编辑</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: 'QuoteManagement',
  data() {
    // 手机号验证
    const validatePhone = (rule, value, callback) => {
      if (!value) {
        callback(new Error('请输入联系电话'));
      } else if (!/^1[3-9]\d{9}$/.test(value)) {
        callback(new Error('请输入正确的手机号码'));
      } else {
        callback();
      }
    };

    return {
      // 搜索表单
      searchForm: {
        quoteNo: '',
        customerName: '',
        status: '',
        dateRange: null
      },
      // 表格数据
      tableData: [],
      loading: false,
      // 分页
      pagination: {
        current: 1,
        size: 10,
        total: 0
      },
      // 对话框
      dialogVisible: false,
      dialogTitle: '新增报价',
      dialogType: 'add',
      submitLoading: false,
      // 表单数据
      form: {
        quoteNo: '',
        customerId: '',
        customerName: '',
        contactPerson: '',
        contactPhone: '',
        quoteDate: '',
        validDays: 30,
        expiryDate: '',
        products: [],
        totalAmount: 0,
        otherFee: 0,
        remark: '',
        paymentMethod: 'cod',
        deliveryTerm: '',
        status: 'draft'
      },
      // 表单验证规则
      rules: {
        customerId: [
          { required: true, message: '请选择客户', trigger: 'change' }
        ],
        contactPerson: [
          { required: true, message: '请输入联系人', trigger: 'blur' }
        ],
        contactPhone: [
          { required: true, validator: validatePhone, trigger: 'blur' }
        ],
        quoteDate: [
          { required: true, message: '请选择报价日期', trigger: 'change' }
        ],
        validDays: [
          { required: true, message: '请输入有效期', trigger: 'blur' }
        ]
      },
      // 详情
      detailVisible: false,
      detailData: {},
      // 选中的行
      selectedRows: [],
      // 客户列表
      customerList: [],
      // 产品列表
      productList: []
    };
  },
  computed: {
    // 产品总金额
    productTotalAmount() {
      return this.form.products.reduce((total, item) => {
        return total + (item.amount || 0);
      }, 0);
    }
  },
  mounted() {
    this.fetchData();
    this.loadCustomerList();
    this.loadProductList();
    // 设置默认报价日期
    this.form.quoteDate = this.formatDate(new Date());
  },
  methods: {
    // 获取列表数据
    async fetchData() {
      this.loading = true;
      try {
        const params = {
          page: this.pagination.current,
          size: this.pagination.size,
          ...this.searchForm
        };

        // 处理日期范围
        if (this.searchForm.dateRange && this.searchForm.dateRange.length === 2) {
          params.startDate = this.searchForm.dateRange[0];
          params.endDate = this.searchForm.dateRange[1];
          delete params.dateRange;
        }

        const response = await axios.get('/api/quotes', { params });

        if (response.data.success) {
          this.tableData = response.data.data.records;
          this.pagination.total = response.data.data.total;
        } else {
          this.$message.error(response.data.message || '获取数据失败');
        }
      } catch (error) {
        console.error('获取报价列表失败:', error);

        // 开发环境使用模拟数据
        if (process.env.NODE_ENV === 'development') {
          this.loadMockData();
        } else {
          this.$message.error('获取数据失败，请稍后重试');
        }
      } finally {
        this.loading = false;
      }
    },

    // 模拟数据
    loadMockData() {
      this.tableData = [
        {
          id: '1',
          quoteNo: 'QT20250103001',
          customerId: 'C001',
          customerName: '上海齿轮制造有限公司',
          contactPerson: '张三',
          contactPhone: '13800138000',
          quoteDate: '2025-01-03',
          validDays: 30,
          expiryDate: '2025-02-02',
          totalAmount: 125000,
          otherFee: 5000,
          productTotal: 120000,
          status: 'approved',
          createUser: '李销售',
          createTime: '2025-01-03 10:00:00',
          updateTime: '2025-01-03 14:30:00',
          products: [
            {
              productId: 'P001',
              productName: 'ZQ250减速机',
              specification: 'ZQ250-40.17-1',
              quantity: 10,
              unitPrice: 10000,
              discount: 1.0,
              amount: 100000,
              remark: '标准配置'
            },
            {
              productId: 'P002',
              productName: 'ZQ350减速机',
              specification: 'ZQ350-50.12-1',
              quantity: 2,
              unitPrice: 10000,
              discount: 1.0,
              amount: 20000,
              remark: ''
            }
          ],
          paymentMethod: 'prepay30',
          deliveryTerm: '收到订单后15个工作日内发货',
          remark: '重要客户，请优先处理'
        },
        {
          id: '2',
          quoteNo: 'QT20250103002',
          customerId: 'C002',
          customerName: '北京机械设备公司',
          contactPerson: '王五',
          contactPhone: '13900139000',
          quoteDate: '2025-01-03',
          validDays: 30,
          expiryDate: '2025-02-02',
          totalAmount: 58000,
          otherFee: 3000,
          productTotal: 55000,
          status: 'pending',
          createUser: '李销售',
          createTime: '2025-01-03 11:30:00',
          updateTime: '2025-01-03 11:30:00',
          products: [
            {
              productId: 'P003',
              productName: 'ZQ400减速机',
              specification: 'ZQ400-31.5-1',
              quantity: 5,
              unitPrice: 11000,
              discount: 1.0,
              amount: 55000,
              remark: ''
            }
          ],
          paymentMethod: 'monthly30',
          deliveryTerm: '收到订单后10个工作日内发货',
          remark: ''
        },
        {
          id: '3',
          quoteNo: 'QT20250103003',
          customerId: 'C003',
          customerName: '广州工业集团',
          contactPerson: '赵六',
          contactPhone: '13700137000',
          quoteDate: '2025-01-03',
          validDays: 30,
          expiryDate: '2025-02-02',
          totalAmount: 32000,
          otherFee: 2000,
          productTotal: 30000,
          status: 'draft',
          createUser: '李销售',
          createTime: '2025-01-03 15:00:00',
          updateTime: '2025-01-03 15:00:00',
          products: [
            {
              productId: 'P004',
              productName: 'ZQ500减速机',
              specification: 'ZQ500-25-1',
              quantity: 2,
              unitPrice: 15000,
              discount: 1.0,
              amount: 30000,
              remark: ''
            }
          ],
          paymentMethod: 'cod',
          deliveryTerm: '收到订单后20个工作日内发货',
          remark: '草稿，待完善'
        }
      ];
      this.pagination.total = 3;
      this.$message.info('当前使用模拟数据');
    },

    // 加载客户列表
    async loadCustomerList() {
      try {
        const response = await axios.get('/api/customers/all');
        if (response.data.success) {
          this.customerList = response.data.data;
        }
      } catch (error) {
        console.error('加载客户列表失败:', error);
        // 使用模拟数据
        this.customerList = [
          { id: 'C001', name: '上海齿轮制造有限公司', contact: '张三', phone: '13800138000' },
          { id: 'C002', name: '北京机械设备公司', contact: '王五', phone: '13900139000' },
          { id: 'C003', name: '广州工业集团', contact: '赵六', phone: '13700137000' }
        ];
      }
    },

    // 加载产品列表
    async loadProductList() {
      try {
        const response = await axios.get('/api/products/all');
        if (response.data.success) {
          this.productList = response.data.data;
        }
      } catch (error) {
        console.error('加载产品列表失败:', error);
        // 使用模拟数据
        this.productList = [
          { id: 'P001', name: 'ZQ250减速机', specification: 'ZQ250-40.17-1', price: 10000 },
          { id: 'P002', name: 'ZQ350减速机', specification: 'ZQ350-50.12-1', price: 10000 },
          { id: 'P003', name: 'ZQ400减速机', specification: 'ZQ400-31.5-1', price: 11000 },
          { id: 'P004', name: 'ZQ500减速机', specification: 'ZQ500-25-1', price: 15000 }
        ];
      }
    },

    // 客户变更
    handleCustomerChange(customerId) {
      const customer = this.customerList.find(c => c.id === customerId);
      if (customer) {
        this.form.customerName = customer.name;
        this.form.contactPerson = customer.contact;
        this.form.contactPhone = customer.phone;
      }
    },

    // 添加产品
    handleAddProduct() {
      this.form.products.push({
        productId: '',
        productName: '',
        specification: '',
        quantity: 1,
        unitPrice: 0,
        discount: 1.0,
        amount: 0,
        remark: ''
      });
    },

    // 移除产品
    handleRemoveProduct(index) {
      this.form.products.splice(index, 1);
      this.calculateTotalAmount();
    },

    // 产品变更
    handleProductChange(index) {
      const productId = this.form.products[index].productId;
      const product = this.productList.find(p => p.id === productId);
      if (product) {
        this.form.products[index].productName = product.name;
        this.form.products[index].specification = product.specification;
        this.form.products[index].unitPrice = product.price;
        this.calculateRowAmount(index);
      }
    },

    // 计算行金额
    calculateRowAmount(index) {
      const row = this.form.products[index];
      row.amount = row.quantity * row.unitPrice * row.discount;
      this.calculateTotalAmount();
    },

    // 计算总金额
    calculateTotalAmount() {
      const productTotal = this.productTotalAmount;
      this.form.totalAmount = productTotal + (this.form.otherFee || 0);
    },

    // 搜索
    handleSearch() {
      this.pagination.current = 1;
      this.fetchData();
    },

    // 重置搜索
    handleReset() {
      this.searchForm = {
        quoteNo: '',
        customerName: '',
        status: '',
        dateRange: null
      };
      this.handleSearch();
    },

    // 新增
    handleAdd() {
      this.dialogType = 'add';
      this.dialogTitle = '新增报价';
      this.form = {
        quoteNo: this.generateQuoteNo(),
        customerId: '',
        customerName: '',
        contactPerson: '',
        contactPhone: '',
        quoteDate: this.formatDate(new Date()),
        validDays: 30,
        expiryDate: '',
        products: [],
        totalAmount: 0,
        otherFee: 0,
        remark: '',
        paymentMethod: 'cod',
        deliveryTerm: '',
        status: 'draft'
      };
      this.dialogVisible = true;
    },

    // 编辑
    handleEdit(row) {
      this.dialogType = 'edit';
      this.dialogTitle = '编辑报价';
      this.form = JSON.parse(JSON.stringify(row));
      this.dialogVisible = true;
      this.detailVisible = false;
    },

    // 查看详情
    handleView(row) {
      this.detailData = JSON.parse(JSON.stringify(row));
      this.detailVisible = true;
    },

    // 删除
    handleDelete(row) {
      this.$confirm(`确定要删除报价单 "${row.quoteNo}" 吗？`, '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(async () => {
        try {
          const response = await axios.delete(`/api/quotes/${row.id}`);
          if (response.data.success) {
            this.$message.success('删除成功');
            this.fetchData();
          } else {
            this.$message.error(response.data.message || '删除失败');
          }
        } catch (error) {
          console.error('删除失败:', error);
          if (process.env.NODE_ENV === 'development') {
            this.$message.success('删除成功（模拟）');
            this.tableData = this.tableData.filter(item => item.id !== row.id);
          } else {
            this.$message.error('删除失败，请稍后重试');
          }
        }
      }).catch(() => {
        this.$message.info('已取消删除');
      });
    },

    // 提交表单
    handleSubmit(status) {
      // 验证产品明细
      if (!this.form.products || this.form.products.length === 0) {
        this.$message.warning('请至少添加一个产品');
        return;
      }

      // 验证产品是否都已选择
      const hasEmptyProduct = this.form.products.some(p => !p.productId);
      if (hasEmptyProduct) {
        this.$message.warning('请完善产品明细信息');
        return;
      }

      this.$refs.quoteForm.validate(async (valid) => {
        if (!valid) {
          return false;
        }

        this.submitLoading = true;
        this.form.status = status;

        // 计算到期日期
        const quoteDate = new Date(this.form.quoteDate);
        const expiryDate = new Date(quoteDate.getTime() + this.form.validDays * 24 * 60 * 60 * 1000);
        this.form.expiryDate = this.formatDate(expiryDate);

        try {
          let response;
          if (this.dialogType === 'add') {
            response = await axios.post('/api/quotes', this.form);
          } else {
            response = await axios.put(`/api/quotes/${this.form.id}`, this.form);
          }

          if (response.data.success) {
            this.$message.success(this.dialogType === 'add' ? '新增成功' : '修改成功');
            this.dialogVisible = false;
            this.fetchData();
          } else {
            this.$message.error(response.data.message || '操作失败');
          }
        } catch (error) {
          console.error('提交失败:', error);
          if (process.env.NODE_ENV === 'development') {
            this.$message.success(`${this.dialogType === 'add' ? '新增' : '修改'}成功（模拟）`);
            this.dialogVisible = false;
            this.fetchData();
          } else {
            this.$message.error('操作失败，请稍后重试');
          }
        } finally {
          this.submitLoading = false;
        }
      });
    },

    // 打印
    handlePrint(row) {
      this.$message.info('打印功能开发中...');
      // TODO: 实现打印功能
    },

    // 转订单
    handleConvertToOrder(row) {
      this.$confirm(`确定要将报价单 "${row.quoteNo}" 转为订单吗？`, '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'info'
      }).then(() => {
        this.$message.info('转订单功能开发中...');
        // TODO: 实现转订单功能
      }).catch(() => {});
    },

    // 对话框关闭
    handleDialogClose() {
      this.$refs.quoteForm.resetFields();
      this.form.products = [];
    },

    // 分页
    handleSizeChange(val) {
      this.pagination.size = val;
      this.pagination.current = 1;
      this.fetchData();
    },

    handleCurrentChange(val) {
      this.pagination.current = val;
      this.fetchData();
    },

    // 表格选择
    handleSelectionChange(selection) {
      this.selectedRows = selection;
    },

    // 导出数据
    handleExport() {
      if (this.tableData.length === 0) {
        this.$message.warning('暂无数据可导出');
        return;
      }
      this.$message.info('导出功能开发中...');
      // TODO: 实现数据导出功能
    },

    // 生成报价单号
    generateQuoteNo() {
      const now = new Date();
      const year = now.getFullYear();
      const month = String(now.getMonth() + 1).padStart(2, '0');
      const day = String(now.getDate()).padStart(2, '0');
      const random = String(Math.floor(Math.random() * 9000) + 1000);
      return `QT${year}${month}${day}${random}`;
    },

    // 格式化日期
    formatDate(date) {
      const d = new Date(date);
      const year = d.getFullYear();
      const month = String(d.getMonth() + 1).padStart(2, '0');
      const day = String(d.getDate()).padStart(2, '0');
      return `${year}-${month}-${day}`;
    },

    // 格式化金额
    formatAmount(amount) {
      if (!amount) return '0.00';
      return Number(amount).toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, ',');
    },

    // 获取状态类型
    getStatusType(status) {
      const statusMap = {
        draft: 'info',
        pending: 'warning',
        approved: 'success',
        rejected: 'danger',
        expired: 'info'
      };
      return statusMap[status] || 'info';
    },

    // 获取状态文本
    getStatusText(status) {
      const statusMap = {
        draft: '草稿',
        pending: '待审批',
        approved: '已审批',
        rejected: '已拒绝',
        expired: '已过期'
      };
      return statusMap[status] || '未知';
    },

    // 获取付款方式文本
    getPaymentMethodText(method) {
      const methodMap = {
        cod: '货到付款',
        prepay30: '预付30%',
        prepay50: '预付50%',
        monthly30: '月结30天',
        other: '其他'
      };
      return methodMap[method] || '未设置';
    }
  }
};
</script>

<style scoped>
.quote-management {
  padding: 20px;
  background: #f5f7fa;
  min-height: calc(100vh - 60px);
}

.page-header {
  background: white;
  padding: 20px 25px;
  border-radius: 8px;
  margin-bottom: 20px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
}

.page-header h2 {
  font-size: 20px;
  color: #303133;
  margin: 0 0 5px 0;
}

.page-header h2 i {
  color: #667eea;
  margin-right: 8px;
}

.page-header p {
  color: #909399;
  font-size: 13px;
  margin: 0;
}

.search-bar {
  background: white;
  padding: 20px 25px 0;
  border-radius: 8px;
  margin-bottom: 20px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
}

.search-form {
  margin: 0;
}

.table-container {
  background: white;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
}

.pagination-container {
  margin-top: 20px;
  text-align: right;
}

.amount-text {
  color: #f56c6c;
  font-weight: 600;
  font-size: 14px;
}

.el-button.danger {
  color: #f56c6c;
}

.el-button.danger:hover {
  color: #f78989;
}

.dialog-footer {
  text-align: right;
}

.form-card {
  margin-bottom: 0;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-weight: 600;
}

.total-section {
  margin-top: 20px;
  padding: 15px 20px;
  background: #f8f9fa;
  border-radius: 4px;
}

.total-section .el-row {
  line-height: 40px;
}

.total-label {
  text-align: right;
  font-size: 14px;
  color: #606266;
}

.total-amount {
  text-align: right;
  font-size: 16px;
  color: #f56c6c;
  font-weight: 600;
}

.total-final .total-label {
  font-size: 16px;
  font-weight: 600;
  color: #303133;
}

.total-final .total-amount {
  font-size: 20px;
  font-weight: 700;
}

.detail-container {
  padding: 10px;
}

.detail-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.detail-header h3 {
  margin: 0;
  font-size: 18px;
  color: #303133;
}

.detail-total {
  margin-top: 20px;
  padding: 15px 20px;
  background: #f8f9fa;
  border-radius: 4px;
  text-align: right;
}

.detail-total p {
  line-height: 35px;
  margin: 0;
  font-size: 14px;
  color: #606266;
}

.detail-total p span {
  color: #f56c6c;
  font-weight: 600;
  margin-left: 20px;
}

.detail-total .total-final {
  font-size: 18px;
  font-weight: 600;
  color: #303133;
  border-top: 2px solid #dcdfe6;
  padding-top: 10px;
  margin-top: 10px;
}

.detail-total .total-final span {
  font-size: 22px;
  font-weight: 700;
}

/* 响应式适配 */
@media (max-width: 768px) {
  .quote-management {
    padding: 10px;
  }

  .page-header {
    flex-direction: column;
    gap: 15px;
    align-items: flex-start;
  }

  .search-form {
    flex-direction: column;
  }

  .search-form .el-form-item {
    width: 100%;
    margin-right: 0;
  }
}
</style>
