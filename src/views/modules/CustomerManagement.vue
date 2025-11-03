<template>
  <div class="customer-management">
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-left">
        <h2><i class="el-icon-user"></i> 客户管理</h2>
        <p>客户信息维护与查询</p>
      </div>
      <div class="header-actions">
        <el-button type="primary" icon="el-icon-plus" @click="handleAdd">新增客户</el-button>
        <el-button type="success" icon="el-icon-download" @click="handleExport">导出数据</el-button>
      </div>
    </div>

    <!-- 搜索栏 -->
    <div class="search-bar">
      <el-form :inline="true" :model="searchForm" class="search-form">
        <el-form-item label="客户名称">
          <el-input
            v-model="searchForm.name"
            placeholder="请输入客户名称"
            clearable
            @clear="handleSearch"
          ></el-input>
        </el-form-item>
        <el-form-item label="客户类型">
          <el-select v-model="searchForm.type" placeholder="请选择" clearable>
            <el-option label="全部" value=""></el-option>
            <el-option label="企业客户" value="enterprise"></el-option>
            <el-option label="个人客户" value="individual"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="客户状态">
          <el-select v-model="searchForm.status" placeholder="请选择" clearable>
            <el-option label="全部" value=""></el-option>
            <el-option label="正常" value="active"></el-option>
            <el-option label="停用" value="inactive"></el-option>
          </el-select>
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
        <el-table-column prop="id" label="客户编号" width="120" sortable></el-table-column>
        <el-table-column prop="name" label="客户名称" min-width="150" show-overflow-tooltip></el-table-column>
        <el-table-column prop="type" label="客户类型" width="120">
          <template slot-scope="scope">
            <el-tag :type="scope.row.type === 'enterprise' ? 'primary' : 'success'" size="small">
              {{ scope.row.type === 'enterprise' ? '企业客户' : '个人客户' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="contact" label="联系人" width="120"></el-table-column>
        <el-table-column prop="phone" label="联系电话" width="140"></el-table-column>
        <el-table-column prop="email" label="邮箱" min-width="180" show-overflow-tooltip></el-table-column>
        <el-table-column prop="address" label="地址" min-width="200" show-overflow-tooltip></el-table-column>
        <el-table-column prop="status" label="状态" width="100" align="center">
          <template slot-scope="scope">
            <el-tag :type="scope.row.status === 'active' ? 'success' : 'info'" size="small">
              {{ scope.row.status === 'active' ? '正常' : '停用' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="200" fixed="right" align="center">
          <template slot-scope="scope">
            <el-button type="text" icon="el-icon-view" @click="handleView(scope.row)">查看</el-button>
            <el-button type="text" icon="el-icon-edit" @click="handleEdit(scope.row)">编辑</el-button>
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
      width="650px"
      :close-on-click-modal="false"
      @close="handleDialogClose"
    >
      <el-form :model="form" :rules="rules" ref="customerForm" label-width="100px">
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="客户名称" prop="name">
              <el-input v-model="form.name" placeholder="请输入客户名称"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="客户类型" prop="type">
              <el-select v-model="form.type" placeholder="请选择" style="width: 100%">
                <el-option label="企业客户" value="enterprise"></el-option>
                <el-option label="个人客户" value="individual"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="联系人" prop="contact">
              <el-input v-model="form.contact" placeholder="请输入联系人"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="联系电话" prop="phone">
              <el-input v-model="form.phone" placeholder="请输入联系电话"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="邮箱" prop="email">
              <el-input v-model="form.email" placeholder="请输入邮箱"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="状态" prop="status">
              <el-radio-group v-model="form.status">
                <el-radio label="active">正常</el-radio>
                <el-radio label="inactive">停用</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="地址" prop="address">
          <el-input v-model="form.address" type="textarea" :rows="2" placeholder="请输入地址"></el-input>
        </el-form-item>
        <el-form-item label="备注">
          <el-input v-model="form.remark" type="textarea" :rows="3" placeholder="请输入备注"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmit" :loading="submitLoading">确定</el-button>
      </div>
    </el-dialog>

    <!-- 查看详情对话框 -->
    <el-dialog title="客户详情" :visible.sync="detailVisible" width="650px">
      <el-descriptions :column="2" border>
        <el-descriptions-item label="客户编号">{{ detailData.id }}</el-descriptions-item>
        <el-descriptions-item label="客户名称">{{ detailData.name }}</el-descriptions-item>
        <el-descriptions-item label="客户类型">
          <el-tag :type="detailData.type === 'enterprise' ? 'primary' : 'success'" size="small">
            {{ detailData.type === 'enterprise' ? '企业客户' : '个人客户' }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="状态">
          <el-tag :type="detailData.status === 'active' ? 'success' : 'info'" size="small">
            {{ detailData.status === 'active' ? '正常' : '停用' }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="联系人">{{ detailData.contact }}</el-descriptions-item>
        <el-descriptions-item label="联系电话">{{ detailData.phone }}</el-descriptions-item>
        <el-descriptions-item label="邮箱" :span="2">{{ detailData.email }}</el-descriptions-item>
        <el-descriptions-item label="地址" :span="2">{{ detailData.address }}</el-descriptions-item>
        <el-descriptions-item label="备注" :span="2">{{ detailData.remark || '无' }}</el-descriptions-item>
        <el-descriptions-item label="创建时间">{{ detailData.createTime }}</el-descriptions-item>
        <el-descriptions-item label="更新时间">{{ detailData.updateTime }}</el-descriptions-item>
      </el-descriptions>
      <div slot="footer" class="dialog-footer">
        <el-button @click="detailVisible = false">关闭</el-button>
        <el-button type="primary" @click="handleEdit(detailData)">编辑</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: 'CustomerManagement',
  data() {
    // 手机号验证规则
    const validatePhone = (rule, value, callback) => {
      if (!value) {
        callback(new Error('请输入联系电话'));
      } else if (!/^1[3-9]\d{9}$/.test(value)) {
        callback(new Error('请输入正确的手机号码'));
      } else {
        callback();
      }
    };

    // 邮箱验证规则
    const validateEmail = (rule, value, callback) => {
      if (!value) {
        callback();
      } else if (!/^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$/.test(value)) {
        callback(new Error('请输入正确的邮箱地址'));
      } else {
        callback();
      }
    };

    return {
      // 搜索表单
      searchForm: {
        name: '',
        type: '',
        status: ''
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
      dialogTitle: '新增客户',
      dialogType: 'add', // add | edit
      submitLoading: false,
      // 表单数据
      form: {
        id: '',
        name: '',
        type: 'enterprise',
        contact: '',
        phone: '',
        email: '',
        address: '',
        status: 'active',
        remark: ''
      },
      // 表单验证规则
      rules: {
        name: [
          { required: true, message: '请输入客户名称', trigger: 'blur' },
          { min: 2, max: 50, message: '长度在 2 到 50 个字符', trigger: 'blur' }
        ],
        type: [
          { required: true, message: '请选择客户类型', trigger: 'change' }
        ],
        contact: [
          { required: true, message: '请输入联系人', trigger: 'blur' }
        ],
        phone: [
          { required: true, validator: validatePhone, trigger: 'blur' }
        ],
        email: [
          { validator: validateEmail, trigger: 'blur' }
        ]
      },
      // 详情
      detailVisible: false,
      detailData: {},
      // 选中的行
      selectedRows: []
    };
  },
  mounted() {
    this.fetchData();
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

        const response = await axios.get('/api/customers', { params });

        if (response.data.success) {
          this.tableData = response.data.data.records;
          this.pagination.total = response.data.data.total;
        } else {
          this.$message.error(response.data.message || '获取数据失败');
        }
      } catch (error) {
        console.error('获取客户列表失败:', error);

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

    // 模拟数据（开发阶段使用）
    loadMockData() {
      this.tableData = [
        {
          id: 'CUS001',
          name: '上海齿轮制造有限公司',
          type: 'enterprise',
          contact: '张三',
          phone: '13800138000',
          email: 'zhangsan@example.com',
          address: '上海市浦东新区张江高科技园区',
          status: 'active',
          remark: '重要客户',
          createTime: '2024-01-01 10:00:00',
          updateTime: '2024-01-15 15:30:00'
        },
        {
          id: 'CUS002',
          name: '北京机械设备公司',
          type: 'enterprise',
          contact: '李四',
          phone: '13900139000',
          email: 'lisi@example.com',
          address: '北京市朝阳区建国路88号',
          status: 'active',
          remark: '',
          createTime: '2024-01-05 14:20:00',
          updateTime: '2024-01-20 09:15:00'
        },
        {
          id: 'CUS003',
          name: '王五',
          type: 'individual',
          contact: '王五',
          phone: '13700137000',
          email: 'wangwu@example.com',
          address: '广州市天河区珠江新城',
          status: 'active',
          remark: '个人采购',
          createTime: '2024-02-01 16:45:00',
          updateTime: '2024-02-10 11:20:00'
        }
      ];
      this.pagination.total = 3;
      this.$message.info('当前使用模拟数据');
    },

    // 搜索
    handleSearch() {
      this.pagination.current = 1;
      this.fetchData();
    },

    // 重置搜索
    handleReset() {
      this.searchForm = {
        name: '',
        type: '',
        status: ''
      };
      this.handleSearch();
    },

    // 新增
    handleAdd() {
      this.dialogType = 'add';
      this.dialogTitle = '新增客户';
      this.form = {
        id: '',
        name: '',
        type: 'enterprise',
        contact: '',
        phone: '',
        email: '',
        address: '',
        status: 'active',
        remark: ''
      };
      this.dialogVisible = true;
    },

    // 编辑
    handleEdit(row) {
      this.dialogType = 'edit';
      this.dialogTitle = '编辑客户';
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
      this.$confirm(`确定要删除客户 "${row.name}" 吗？`, '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(async () => {
        try {
          const response = await axios.delete(`/api/customers/${row.id}`);
          if (response.data.success) {
            this.$message.success('删除成功');
            this.fetchData();
          } else {
            this.$message.error(response.data.message || '删除失败');
          }
        } catch (error) {
          console.error('删除失败:', error);
          // 开发环境模拟删除成功
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
    handleSubmit() {
      this.$refs.customerForm.validate(async (valid) => {
        if (!valid) {
          return false;
        }

        this.submitLoading = true;
        try {
          let response;
          if (this.dialogType === 'add') {
            response = await axios.post('/api/customers', this.form);
          } else {
            response = await axios.put(`/api/customers/${this.form.id}`, this.form);
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
          // 开发环境模拟提交成功
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

    // 对话框关闭
    handleDialogClose() {
      this.$refs.customerForm.resetFields();
    },

    // 分页：每页条数改变
    handleSizeChange(val) {
      this.pagination.size = val;
      this.pagination.current = 1;
      this.fetchData();
    },

    // 分页：当前页改变
    handleCurrentChange(val) {
      this.pagination.current = val;
      this.fetchData();
    },

    // 表格选择改变
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
    }
  }
};
</script>

<style scoped>
.customer-management {
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

.el-button.danger {
  color: #f56c6c;
}

.el-button.danger:hover {
  color: #f78989;
}

.dialog-footer {
  text-align: right;
}

/* 响应式适配 */
@media (max-width: 768px) {
  .customer-management {
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
