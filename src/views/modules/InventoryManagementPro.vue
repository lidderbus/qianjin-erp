<template>
  <div class="inventory-management-pro">
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-left">
        <h2><i class="el-icon-box"></i> 配件库存管理Pro</h2>
        <p>智能库存分析系统 - 实时监控，精准管理</p>
      </div>
      <div class="header-actions">
        <el-button type="primary" icon="el-icon-plus" @click="handleAdd">新增配件</el-button>
        <el-button type="success" icon="el-icon-upload2" @click="handleInStock">入库</el-button>
        <el-button type="warning" icon="el-icon-download" @click="handleOutStock">出库</el-button>
        <el-button type="info" icon="el-icon-s-data" @click="showStatistics = true">统计分析</el-button>
      </div>
    </div>

    <!-- 统计卡片 -->
    <div class="stats-grid">
      <div class="stat-card blue">
        <div class="stat-icon"><i class="el-icon-goods"></i></div>
        <div class="stat-info">
          <div class="stat-value">{{ stats.totalCount }}</div>
          <div class="stat-label">配件总数</div>
        </div>
      </div>
      <div class="stat-card green">
        <div class="stat-icon"><i class="el-icon-box"></i></div>
        <div class="stat-info">
          <div class="stat-value">{{ stats.totalQuantity }}</div>
          <div class="stat-label">库存总量</div>
        </div>
      </div>
      <div class="stat-card orange">
        <div class="stat-icon"><i class="el-icon-warning"></i></div>
        <div class="stat-info">
          <div class="stat-value">{{ stats.lowStockCount }}</div>
          <div class="stat-label">低库存预警</div>
        </div>
      </div>
      <div class="stat-card red">
        <div class="stat-icon"><i class="el-icon-circle-close"></i></div>
        <div class="stat-info">
          <div class="stat-value">{{ stats.outOfStockCount }}</div>
          <div class="stat-label">零库存</div>
        </div>
      </div>
      <div class="stat-card purple">
        <div class="stat-icon"><i class="el-icon-coin"></i></div>
        <div class="stat-info">
          <div class="stat-value">¥{{ formatAmount(stats.totalValue) }}</div>
          <div class="stat-label">库存总金额</div>
        </div>
      </div>
    </div>

    <!-- 搜索栏 -->
    <div class="search-bar">
      <el-form :inline="true" :model="searchForm" class="search-form">
        <el-form-item label="配件编号">
          <el-input
            v-model="searchForm.partNo"
            placeholder="请输入配件编号"
            clearable
            @clear="handleSearch"
          ></el-input>
        </el-form-item>
        <el-form-item label="配件名称">
          <el-input
            v-model="searchForm.partName"
            placeholder="请输入配件名称"
            clearable
            @clear="handleSearch"
          ></el-input>
        </el-form-item>
        <el-form-item label="配件分类">
          <el-select v-model="searchForm.category" placeholder="请选择" clearable>
            <el-option label="全部" value=""></el-option>
            <el-option label="齿轮" value="gear"></el-option>
            <el-option label="轴承" value="bearing"></el-option>
            <el-option label="密封件" value="seal"></el-option>
            <el-option label="润滑油" value="oil"></el-option>
            <el-option label="其他" value="other"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="库存状态">
          <el-select v-model="searchForm.stockStatus" placeholder="请选择" clearable>
            <el-option label="全部" value=""></el-option>
            <el-option label="正常" value="normal"></el-option>
            <el-option label="低库存" value="low"></el-option>
            <el-option label="零库存" value="out"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" icon="el-icon-search" @click="handleSearch">搜索</el-button>
          <el-button icon="el-icon-refresh" @click="handleReset">重置</el-button>
          <el-button type="success" icon="el-icon-download" @click="handleExport">导出</el-button>
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
        <el-table-column prop="partNo" label="配件编号" width="130" sortable fixed="left"></el-table-column>
        <el-table-column prop="partName" label="配件名称" min-width="150" show-overflow-tooltip></el-table-column>
        <el-table-column prop="category" label="分类" width="100">
          <template slot-scope="scope">
            <el-tag size="small">{{ getCategoryText(scope.row.category) }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="specification" label="规格型号" width="150" show-overflow-tooltip></el-table-column>
        <el-table-column prop="unit" label="单位" width="70" align="center"></el-table-column>
        <el-table-column prop="quantity" label="当前库存" width="100" sortable align="center">
          <template slot-scope="scope">
            <span :class="getQuantityClass(scope.row)">{{ scope.row.quantity }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="minStock" label="最低库存" width="100" align="center"></el-table-column>
        <el-table-column prop="maxStock" label="最高库存" width="100" align="center"></el-table-column>
        <el-table-column label="库存状态" width="100" align="center">
          <template slot-scope="scope">
            <el-tag :type="getStockStatusType(scope.row)" size="small">
              {{ getStockStatusText(scope.row) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="unitPrice" label="单价（元）" width="120" align="right">
          <template slot-scope="scope">
            ¥{{ formatAmount(scope.row.unitPrice) }}
          </template>
        </el-table-column>
        <el-table-column label="库存金额（元）" width="130" align="right">
          <template slot-scope="scope">
            <span class="amount-text">¥{{ formatAmount(scope.row.quantity * scope.row.unitPrice) }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="location" label="存放位置" width="120"></el-table-column>
        <el-table-column prop="updateTime" label="更新时间" width="160" sortable></el-table-column>
        <el-table-column label="操作" width="260" fixed="right" align="center">
          <template slot-scope="scope">
            <el-button type="text" icon="el-icon-view" @click="handleView(scope.row)">查看</el-button>
            <el-button type="text" icon="el-icon-edit" @click="handleEdit(scope.row)">编辑</el-button>
            <el-button type="text" icon="el-icon-s-order" @click="handleStockRecord(scope.row)">出入库记录</el-button>
            <el-button type="text" icon="el-icon-delete" class="danger" @click="handleDelete(scope.row)">删除</el-button>
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
      width="700px"
      :close-on-click-modal="false"
      @close="handleDialogClose"
    >
      <el-form :model="form" :rules="rules" ref="partForm" label-width="100px">
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="配件编号" prop="partNo">
              <el-input v-model="form.partNo" placeholder="请输入配件编号"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="配件名称" prop="partName">
              <el-input v-model="form.partName" placeholder="请输入配件名称"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="配件分类" prop="category">
              <el-select v-model="form.category" placeholder="请选择" style="width: 100%">
                <el-option label="齿轮" value="gear"></el-option>
                <el-option label="轴承" value="bearing"></el-option>
                <el-option label="密封件" value="seal"></el-option>
                <el-option label="润滑油" value="oil"></el-option>
                <el-option label="其他" value="other"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="规格型号" prop="specification">
              <el-input v-model="form.specification" placeholder="请输入规格型号"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="8">
            <el-form-item label="单位" prop="unit">
              <el-select v-model="form.unit" placeholder="请选择" style="width: 100%">
                <el-option label="个" value="个"></el-option>
                <el-option label="件" value="件"></el-option>
                <el-option label="台" value="台"></el-option>
                <el-option label="套" value="套"></el-option>
                <el-option label="箱" value="箱"></el-option>
                <el-option label="升" value="升"></el-option>
                <el-option label="公斤" value="公斤"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="当前库存" prop="quantity">
              <el-input-number v-model="form.quantity" :min="0" :precision="0" style="width: 100%"></el-input-number>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="单价（元）" prop="unitPrice">
              <el-input-number v-model="form.unitPrice" :min="0" :precision="2" style="width: 100%"></el-input-number>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="8">
            <el-form-item label="最低库存" prop="minStock">
              <el-input-number v-model="form.minStock" :min="0" :precision="0" style="width: 100%"></el-input-number>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="最高库存" prop="maxStock">
              <el-input-number v-model="form.maxStock" :min="0" :precision="0" style="width: 100%"></el-input-number>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="存放位置" prop="location">
              <el-input v-model="form.location" placeholder="如：A区-1号货架"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="备注说明">
          <el-input v-model="form.remark" type="textarea" :rows="3" placeholder="请输入备注说明"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmit" :loading="submitLoading">确定</el-button>
      </div>
    </el-dialog>

    <!-- 入库对话框 -->
    <el-dialog title="配件入库" :visible.sync="inStockVisible" width="600px" :close-on-click-modal="false">
      <el-form :model="stockForm" :rules="stockRules" ref="inStockForm" label-width="100px">
        <el-form-item label="配件" prop="partId">
          <el-select v-model="stockForm.partId" placeholder="请选择配件" filterable style="width: 100%"
            @change="handlePartSelect">
            <el-option
              v-for="part in tableData"
              :key="part.id"
              :label="`${part.partNo} - ${part.partName}`"
              :value="part.id"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="当前库存">
          <el-input v-model="stockForm.currentQuantity" disabled></el-input>
        </el-form-item>
        <el-form-item label="入库数量" prop="quantity">
          <el-input-number v-model="stockForm.quantity" :min="1" :precision="0" style="width: 100%"></el-input-number>
        </el-form-item>
        <el-form-item label="入库后库存">
          <el-input :value="stockForm.currentQuantity + stockForm.quantity" disabled></el-input>
        </el-form-item>
        <el-form-item label="入库原因" prop="reason">
          <el-select v-model="stockForm.reason" placeholder="请选择" style="width: 100%">
            <el-option label="采购入库" value="purchase"></el-option>
            <el-option label="生产入库" value="production"></el-option>
            <el-option label="退货入库" value="return"></el-option>
            <el-option label="盘盈" value="surplus"></el-option>
            <el-option label="其他" value="other"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="备注">
          <el-input v-model="stockForm.remark" type="textarea" :rows="3" placeholder="请输入备注"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="inStockVisible = false">取消</el-button>
        <el-button type="success" @click="handleInStockSubmit" :loading="stockLoading">确认入库</el-button>
      </div>
    </el-dialog>

    <!-- 出库对话框 -->
    <el-dialog title="配件出库" :visible.sync="outStockVisible" width="600px" :close-on-click-modal="false">
      <el-form :model="stockForm" :rules="stockRules" ref="outStockForm" label-width="100px">
        <el-form-item label="配件" prop="partId">
          <el-select v-model="stockForm.partId" placeholder="请选择配件" filterable style="width: 100%"
            @change="handlePartSelect">
            <el-option
              v-for="part in tableData"
              :key="part.id"
              :label="`${part.partNo} - ${part.partName}`"
              :value="part.id"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="当前库存">
          <el-input v-model="stockForm.currentQuantity" disabled></el-input>
        </el-form-item>
        <el-form-item label="出库数量" prop="quantity">
          <el-input-number v-model="stockForm.quantity" :min="1" :max="stockForm.currentQuantity" :precision="0"
            style="width: 100%"></el-input-number>
        </el-form-item>
        <el-form-item label="出库后库存">
          <el-input :value="Math.max(0, stockForm.currentQuantity - stockForm.quantity)" disabled></el-input>
        </el-form-item>
        <el-form-item label="出库原因" prop="reason">
          <el-select v-model="stockForm.reason" placeholder="请选择" style="width: 100%">
            <el-option label="销售出库" value="sales"></el-option>
            <el-option label="生产领用" value="production"></el-option>
            <el-option label="维修使用" value="maintenance"></el-option>
            <el-option label="盘亏" value="shortage"></el-option>
            <el-option label="其他" value="other"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="备注">
          <el-input v-model="stockForm.remark" type="textarea" :rows="3" placeholder="请输入备注"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="outStockVisible = false">取消</el-button>
        <el-button type="warning" @click="handleOutStockSubmit" :loading="stockLoading">确认出库</el-button>
      </div>
    </el-dialog>

    <!-- 查看详情对话框 -->
    <el-dialog title="配件详情" :visible.sync="detailVisible" width="700px">
      <el-descriptions :column="2" border v-if="detailData.partNo">
        <el-descriptions-item label="配件编号">{{ detailData.partNo }}</el-descriptions-item>
        <el-descriptions-item label="配件名称">{{ detailData.partName }}</el-descriptions-item>
        <el-descriptions-item label="配件分类">{{ getCategoryText(detailData.category) }}</el-descriptions-item>
        <el-descriptions-item label="规格型号">{{ detailData.specification }}</el-descriptions-item>
        <el-descriptions-item label="单位">{{ detailData.unit }}</el-descriptions-item>
        <el-descriptions-item label="当前库存">
          <span :class="getQuantityClass(detailData)">{{ detailData.quantity }}</span>
        </el-descriptions-item>
        <el-descriptions-item label="最低库存">{{ detailData.minStock }}</el-descriptions-item>
        <el-descriptions-item label="最高库存">{{ detailData.maxStock }}</el-descriptions-item>
        <el-descriptions-item label="库存状态">
          <el-tag :type="getStockStatusType(detailData)" size="small">
            {{ getStockStatusText(detailData) }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="单价">¥{{ formatAmount(detailData.unitPrice) }}</el-descriptions-item>
        <el-descriptions-item label="库存金额" :span="2">
          <span class="amount-text">¥{{ formatAmount(detailData.quantity * detailData.unitPrice) }}</span>
        </el-descriptions-item>
        <el-descriptions-item label="存放位置">{{ detailData.location }}</el-descriptions-item>
        <el-descriptions-item label="创建时间">{{ detailData.createTime }}</el-descriptions-item>
        <el-descriptions-item label="更新时间" :span="2">{{ detailData.updateTime }}</el-descriptions-item>
        <el-descriptions-item label="备注" :span="2">{{ detailData.remark || '无' }}</el-descriptions-item>
      </el-descriptions>
      <div slot="footer" class="dialog-footer">
        <el-button @click="detailVisible = false">关闭</el-button>
        <el-button type="primary" @click="handleEdit(detailData)">编辑</el-button>
      </div>
    </el-dialog>

    <!-- 出入库记录对话框 -->
    <el-dialog title="出入库记录" :visible.sync="recordVisible" width="900px">
      <el-table :data="stockRecords" border style="width: 100%" v-loading="recordLoading">
        <el-table-column type="index" label="序号" width="60" align="center"></el-table-column>
        <el-table-column prop="type" label="类型" width="80" align="center">
          <template slot-scope="scope">
            <el-tag :type="scope.row.type === 'in' ? 'success' : 'warning'" size="small">
              {{ scope.row.type === 'in' ? '入库' : '出库' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="quantity" label="数量" width="100" align="center"></el-table-column>
        <el-table-column prop="beforeQuantity" label="变更前库存" width="120" align="center"></el-table-column>
        <el-table-column prop="afterQuantity" label="变更后库存" width="120" align="center"></el-table-column>
        <el-table-column prop="reason" label="原因" width="120"></el-table-column>
        <el-table-column prop="operator" label="操作人" width="100"></el-table-column>
        <el-table-column prop="operateTime" label="操作时间" width="160"></el-table-column>
        <el-table-column prop="remark" label="备注" min-width="150" show-overflow-tooltip></el-table-column>
      </el-table>
      <div slot="footer" class="dialog-footer">
        <el-button @click="recordVisible = false">关闭</el-button>
      </div>
    </el-dialog>

    <!-- 统计分析对话框 -->
    <el-dialog title="库存统计分析" :visible.sync="showStatistics" width="90%" top="5vh">
      <div class="statistics-container">
        <el-row :gutter="20">
          <el-col :span="8">
            <el-card shadow="hover">
              <div slot="header">库存分类统计</div>
              <div class="chart-container" ref="categoryChart"></div>
            </el-card>
          </el-col>
          <el-col :span="8">
            <el-card shadow="hover">
              <div slot="header">库存状态分布</div>
              <div class="chart-container" ref="statusChart"></div>
            </el-card>
          </el-col>
          <el-col :span="8">
            <el-card shadow="hover">
              <div slot="header">库存金额TOP10</div>
              <div class="chart-container" ref="valueChart"></div>
            </el-card>
          </el-col>
        </el-row>
      </div>
      <div slot="footer" class="dialog-footer">
        <el-button @click="showStatistics = false">关闭</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: 'InventoryManagementPro',
  data() {
    return {
      // 搜索表单
      searchForm: {
        partNo: '',
        partName: '',
        category: '',
        stockStatus: ''
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
      // 统计数据
      stats: {
        totalCount: 0,
        totalQuantity: 0,
        lowStockCount: 0,
        outOfStockCount: 0,
        totalValue: 0
      },
      // 对话框
      dialogVisible: false,
      dialogTitle: '新增配件',
      dialogType: 'add',
      submitLoading: false,
      // 表单数据
      form: {
        partNo: '',
        partName: '',
        category: '',
        specification: '',
        unit: '个',
        quantity: 0,
        minStock: 10,
        maxStock: 1000,
        unitPrice: 0,
        location: '',
        remark: ''
      },
      // 表单验证规则
      rules: {
        partNo: [
          { required: true, message: '请输入配件编号', trigger: 'blur' }
        ],
        partName: [
          { required: true, message: '请输入配件名称', trigger: 'blur' }
        ],
        category: [
          { required: true, message: '请选择配件分类', trigger: 'change' }
        ],
        unit: [
          { required: true, message: '请选择单位', trigger: 'change' }
        ],
        unitPrice: [
          { required: true, message: '请输入单价', trigger: 'blur' }
        ]
      },
      // 详情
      detailVisible: false,
      detailData: {},
      // 选中的行
      selectedRows: [],
      // 入库对话框
      inStockVisible: false,
      // 出库对话框
      outStockVisible: false,
      // 出入库表单
      stockForm: {
        partId: '',
        currentQuantity: 0,
        quantity: 0,
        reason: '',
        remark: ''
      },
      stockRules: {
        partId: [
          { required: true, message: '请选择配件', trigger: 'change' }
        ],
        quantity: [
          { required: true, message: '请输入数量', trigger: 'blur' }
        ],
        reason: [
          { required: true, message: '请选择原因', trigger: 'change' }
        ]
      },
      stockLoading: false,
      // 出入库记录
      recordVisible: false,
      stockRecords: [],
      recordLoading: false,
      // 统计分析
      showStatistics: false
    };
  },
  mounted() {
    this.fetchData();
    this.fetchStats();
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

        const response = await axios.get('/api/inventory/parts', { params });

        if (response.data.success) {
          this.tableData = response.data.data.records;
          this.pagination.total = response.data.data.total;
        } else {
          this.$message.error(response.data.message || '获取数据失败');
        }
      } catch (error) {
        console.error('获取配件列表失败:', error);

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
          partNo: 'PART001',
          partName: 'ZQ250减速机齿轮',
          category: 'gear',
          specification: 'Z=40, M=5',
          unit: '个',
          quantity: 150,
          minStock: 50,
          maxStock: 500,
          unitPrice: 850,
          location: 'A区-1号货架',
          createTime: '2024-01-01 10:00:00',
          updateTime: '2025-01-03 15:30:00',
          remark: '常用配件，需保持充足库存'
        },
        {
          id: '2',
          partNo: 'PART002',
          partName: '深沟球轴承',
          category: 'bearing',
          specification: '6308',
          unit: '个',
          quantity: 25,
          minStock: 30,
          maxStock: 200,
          unitPrice: 120,
          location: 'A区-2号货架',
          createTime: '2024-01-02 11:00:00',
          updateTime: '2025-01-03 16:00:00',
          remark: '低于最低库存，需要补货'
        },
        {
          id: '3',
          partNo: 'PART003',
          partName: '橡胶密封圈',
          category: 'seal',
          specification: 'Φ100×5',
          unit: '个',
          quantity: 0,
          minStock: 20,
          maxStock: 100,
          unitPrice: 15,
          location: 'B区-1号货架',
          createTime: '2024-01-03 12:00:00',
          updateTime: '2025-01-03 14:00:00',
          remark: '零库存，紧急补货'
        },
        {
          id: '4',
          partNo: 'PART004',
          partName: '工业齿轮油',
          category: 'oil',
          specification: '320#, 18L/桶',
          unit: '桶',
          quantity: 80,
          minStock: 20,
          maxStock: 100,
          unitPrice: 250,
          location: 'C区-仓库',
          createTime: '2024-01-04 13:00:00',
          updateTime: '2025-01-02 10:00:00',
          remark: '库存正常'
        },
        {
          id: '5',
          partNo: 'PART005',
          partName: 'ZQ350减速机齿轮',
          category: 'gear',
          specification: 'Z=50, M=6',
          unit: '个',
          quantity: 220,
          minStock: 60,
          maxStock: 600,
          unitPrice: 1200,
          location: 'A区-1号货架',
          createTime: '2024-01-05 14:00:00',
          updateTime: '2025-01-03 11:00:00',
          remark: '库存充足'
        }
      ];
      this.pagination.total = 5;
      this.$message.info('当前使用模拟数据');
    },

    // 获取统计数据
    fetchStats() {
      // 计算统计数据
      this.stats.totalCount = this.tableData.length;
      this.stats.totalQuantity = this.tableData.reduce((sum, item) => sum + item.quantity, 0);
      this.stats.lowStockCount = this.tableData.filter(item => item.quantity > 0 && item.quantity < item.minStock).length;
      this.stats.outOfStockCount = this.tableData.filter(item => item.quantity === 0).length;
      this.stats.totalValue = this.tableData.reduce((sum, item) => sum + (item.quantity * item.unitPrice), 0);
    },

    // 搜索
    handleSearch() {
      this.pagination.current = 1;
      this.fetchData();
    },

    // 重置搜索
    handleReset() {
      this.searchForm = {
        partNo: '',
        partName: '',
        category: '',
        stockStatus: ''
      };
      this.handleSearch();
    },

    // 新增
    handleAdd() {
      this.dialogType = 'add';
      this.dialogTitle = '新增配件';
      this.form = {
        partNo: '',
        partName: '',
        category: '',
        specification: '',
        unit: '个',
        quantity: 0,
        minStock: 10,
        maxStock: 1000,
        unitPrice: 0,
        location: '',
        remark: ''
      };
      this.dialogVisible = true;
    },

    // 编辑
    handleEdit(row) {
      this.dialogType = 'edit';
      this.dialogTitle = '编辑配件';
      this.form = { ...row };
      this.dialogVisible = true;
      this.detailVisible = false;
    },

    // 查看详情
    handleView(row) {
      this.detailData = { ...row };
      this.detailVisible = true;
    },

    // 删除
    handleDelete(row) {
      this.$confirm(`确定要删除配件 "${row.partName}" 吗？`, '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(async () => {
        try {
          const response = await axios.delete(`/api/inventory/parts/${row.id}`);
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
            this.fetchStats();
          } else {
            this.$message.error('删除失败，请稍后重试');
          }
        }
      }).catch(() => {
        this.$message.info('已取消删除');
      });
    },

    // 提交表单
    handleSubmit() {
      this.$refs.partForm.validate(async (valid) => {
        if (!valid) {
          return false;
        }

        this.submitLoading = true;
        try {
          let response;
          if (this.dialogType === 'add') {
            response = await axios.post('/api/inventory/parts', this.form);
          } else {
            response = await axios.put(`/api/inventory/parts/${this.form.id}`, this.form);
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

    // 入库
    handleInStock() {
      this.stockForm = {
        partId: '',
        currentQuantity: 0,
        quantity: 0,
        reason: '',
        remark: ''
      };
      this.inStockVisible = true;
    },

    // 出库
    handleOutStock() {
      this.stockForm = {
        partId: '',
        currentQuantity: 0,
        quantity: 0,
        reason: '',
        remark: ''
      };
      this.outStockVisible = true;
    },

    // 选择配件
    handlePartSelect(partId) {
      const part = this.tableData.find(p => p.id === partId);
      if (part) {
        this.stockForm.currentQuantity = part.quantity;
      }
    },

    // 入库提交
    handleInStockSubmit() {
      this.$refs.inStockForm.validate(async (valid) => {
        if (!valid) {
          return false;
        }

        this.stockLoading = true;
        try {
          const response = await axios.post('/api/inventory/in-stock', this.stockForm);
          if (response.data.success) {
            this.$message.success('入库成功');
            this.inStockVisible = false;
            this.fetchData();
          } else {
            this.$message.error(response.data.message || '入库失败');
          }
        } catch (error) {
          console.error('入库失败:', error);
          if (process.env.NODE_ENV === 'development') {
            this.$message.success('入库成功（模拟）');
            this.inStockVisible = false;
            this.fetchData();
          } else {
            this.$message.error('入库失败，请稍后重试');
          }
        } finally {
          this.stockLoading = false;
        }
      });
    },

    // 出库提交
    handleOutStockSubmit() {
      this.$refs.outStockForm.validate(async (valid) => {
        if (!valid) {
          return false;
        }

        // 检查库存是否足够
        if (this.stockForm.quantity > this.stockForm.currentQuantity) {
          this.$message.warning('出库数量不能大于当前库存');
          return;
        }

        this.stockLoading = true;
        try {
          const response = await axios.post('/api/inventory/out-stock', this.stockForm);
          if (response.data.success) {
            this.$message.success('出库成功');
            this.outStockVisible = false;
            this.fetchData();
          } else {
            this.$message.error(response.data.message || '出库失败');
          }
        } catch (error) {
          console.error('出库失败:', error);
          if (process.env.NODE_ENV === 'development') {
            this.$message.success('出库成功（模拟）');
            this.outStockVisible = false;
            this.fetchData();
          } else {
            this.$message.error('出库失败，请稍后重试');
          }
        } finally {
          this.stockLoading = false;
        }
      });
    },

    // 出入库记录
    handleStockRecord(row) {
      this.recordLoading = true;
      this.recordVisible = true;

      // 模拟数据
      setTimeout(() => {
        this.stockRecords = [
          {
            type: 'in',
            quantity: 50,
            beforeQuantity: 100,
            afterQuantity: 150,
            reason: '采购入库',
            operator: '张三',
            operateTime: '2025-01-03 10:00:00',
            remark: '供应商：XX公司'
          },
          {
            type: 'out',
            quantity: 30,
            beforeQuantity: 150,
            afterQuantity: 120,
            reason: '生产领用',
            operator: '李四',
            operateTime: '2025-01-02 14:30:00',
            remark: '生产订单：PO2025010001'
          },
          {
            type: 'in',
            quantity: 100,
            beforeQuantity: 50,
            afterQuantity: 150,
            reason: '采购入库',
            operator: '王五',
            operateTime: '2025-01-01 09:00:00',
            remark: '首次入库'
          }
        ];
        this.recordLoading = false;
      }, 500);
    },

    // 对话框关闭
    handleDialogClose() {
      this.$refs.partForm.resetFields();
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

    // 格式化金额
    formatAmount(amount) {
      if (!amount && amount !== 0) return '0.00';
      return Number(amount).toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, ',');
    },

    // 获取分类文本
    getCategoryText(category) {
      const categoryMap = {
        gear: '齿轮',
        bearing: '轴承',
        seal: '密封件',
        oil: '润滑油',
        other: '其他'
      };
      return categoryMap[category] || '未知';
    },

    // 获取库存数量样式
    getQuantityClass(row) {
      if (row.quantity === 0) {
        return 'quantity-danger';
      } else if (row.quantity < row.minStock) {
        return 'quantity-warning';
      } else {
        return 'quantity-normal';
      }
    },

    // 获取库存状态类型
    getStockStatusType(row) {
      if (row.quantity === 0) {
        return 'danger';
      } else if (row.quantity < row.minStock) {
        return 'warning';
      } else {
        return 'success';
      }
    },

    // 获取库存状态文本
    getStockStatusText(row) {
      if (row.quantity === 0) {
        return '零库存';
      } else if (row.quantity < row.minStock) {
        return '低库存';
      } else {
        return '正常';
      }
    }
  }
};
</script>

<style scoped>
.inventory-management-pro {
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

.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 15px;
  margin-bottom: 20px;
}

.stat-card {
  background: white;
  border-radius: 8px;
  padding: 20px;
  display: flex;
  align-items: center;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
  cursor: pointer;
  transition: transform 0.3s;
}

.stat-card:hover {
  transform: translateY(-3px);
}

.stat-icon {
  width: 60px;
  height: 60px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 28px;
  color: white;
  margin-right: 15px;
}

.stat-card.blue .stat-icon {
  background: linear-gradient(135deg, #667eea, #764ba2);
}

.stat-card.green .stat-icon {
  background: linear-gradient(135deg, #06d6a0, #0ead69);
}

.stat-card.orange .stat-icon {
  background: linear-gradient(135deg, #ff9a3c, #ff6a00);
}

.stat-card.red .stat-icon {
  background: linear-gradient(135deg, #ef476f, #d32f2f);
}

.stat-card.purple .stat-icon {
  background: linear-gradient(135deg, #9c27b0, #673ab7);
}

.stat-info {
  flex: 1;
}

.stat-value {
  font-size: 24px;
  font-weight: 700;
  color: #303133;
  margin-bottom: 5px;
}

.stat-label {
  font-size: 13px;
  color: #909399;
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

.quantity-danger {
  color: #f56c6c;
  font-weight: 700;
  font-size: 16px;
}

.quantity-warning {
  color: #e6a23c;
  font-weight: 600;
  font-size: 16px;
}

.quantity-normal {
  color: #67c23a;
  font-weight: 600;
  font-size: 16px;
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

.statistics-container {
  padding: 10px;
}

.chart-container {
  width: 100%;
  height: 300px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #909399;
}

/* 响应式适配 */
@media (max-width: 768px) {
  .inventory-management-pro {
    padding: 10px;
  }

  .page-header {
    flex-direction: column;
    gap: 15px;
    align-items: flex-start;
  }

  .stats-grid {
    grid-template-columns: 1fr;
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
