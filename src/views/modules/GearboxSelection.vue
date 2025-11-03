<template>
  <div class="gearbox-selection">
    <!-- 页面标题 -->
    <div class="page-header">
      <h2>⚙️ 齿轮箱选型系统</h2>
      <p class="subtitle">智能推荐 · 精准匹配 · 专业可靠</p>
    </div>

    <!-- 统计卡片 -->
    <el-row :gutter="20" class="stats-row">
      <el-col :xs="24" :sm="12" :md="6" :lg="6">
        <div class="stats-card">
          <div class="stats-content">
            <div class="icon-wrapper">
              <i class="el-icon-files"></i>
            </div>
            <div class="stats-info">
              <div class="value">{{ gearboxLibrary.length }}</div>
              <div class="label">型号库存</div>
            </div>
          </div>
        </div>
      </el-col>
      <el-col :xs="24" :sm="12" :md="6" :lg="6">
        <div class="stats-card">
          <div class="stats-content">
            <div class="icon-wrapper">
              <i class="el-icon-s-data"></i>
            </div>
            <div class="stats-info">
              <div class="value">{{ selectionHistory.length }}</div>
              <div class="label">选型记录</div>
            </div>
          </div>
        </div>
      </el-col>
      <el-col :xs="24" :sm="12" :md="6" :lg="6">
        <div class="stats-card">
          <div class="stats-content">
            <div class="icon-wrapper">
              <i class="el-icon-success"></i>
            </div>
            <div class="stats-info">
              <div class="value">{{ successRate }}%</div>
              <div class="label">成功率</div>
            </div>
          </div>
        </div>
      </el-col>
      <el-col :xs="24" :sm="12" :md="6" :lg="6">
        <div class="stats-card">
          <div class="stats-content">
            <div class="icon-wrapper">
              <i class="el-icon-star-on"></i>
            </div>
            <div class="stats-info">
              <div class="value">{{ popularModel }}</div>
              <div class="label">热门型号</div>
            </div>
          </div>
        </div>
      </el-col>
    </el-row>

    <!-- Tab 切换 -->
    <el-tabs v-model="activeTab" class="main-tabs">
      <!-- Tab 1: 智能选型 -->
      <el-tab-pane label="🎯 智能选型" name="selection">
        <el-card shadow="hover" class="selection-card">
          <!-- 选型表单 -->
          <div class="selection-form-wrapper">
            <el-steps :active="currentStep" finish-status="success" align-center>
              <el-step title="基础参数" icon="el-icon-edit"></el-step>
              <el-step title="应用条件" icon="el-icon-setting"></el-step>
              <el-step title="智能推荐" icon="el-icon-star-on"></el-step>
              <el-step title="确认下单" icon="el-icon-check"></el-step>
            </el-steps>

            <div class="step-content">
              <!-- 步骤 1: 基础参数 -->
              <div v-show="currentStep === 0" class="step-panel">
                <h3>📝 请输入基础参数</h3>
                <el-form
                  ref="basicForm"
                  :model="selectionForm"
                  :rules="selectionRules"
                  label-width="140px"
                  class="selection-form"
                >
                  <el-row :gutter="20">
                    <el-col :span="12">
                      <el-form-item label="电机功率" prop="motorPower">
                        <el-input
                          v-model.number="selectionForm.motorPower"
                          placeholder="请输入功率"
                          @input="calculateReductionRatio"
                        >
                          <template slot="append">kW</template>
                        </el-input>
                      </el-form-item>
                    </el-col>
                    <el-col :span="12">
                      <el-form-item label="电机转速" prop="motorSpeed">
                        <el-input
                          v-model.number="selectionForm.motorSpeed"
                          placeholder="请输入转速"
                          @input="calculateReductionRatio"
                        >
                          <template slot="append">rpm</template>
                        </el-input>
                      </el-form-item>
                    </el-col>
                  </el-row>

                  <el-row :gutter="20">
                    <el-col :span="12">
                      <el-form-item label="输出转速" prop="outputSpeed">
                        <el-input
                          v-model.number="selectionForm.outputSpeed"
                          placeholder="请输入输出转速"
                          @input="calculateReductionRatio"
                        >
                          <template slot="append">rpm</template>
                        </el-input>
                      </el-form-item>
                    </el-col>
                    <el-col :span="12">
                      <el-form-item label="减速比">
                        <el-input
                          :value="reductionRatio"
                          readonly
                          placeholder="自动计算"
                        >
                          <template slot="append">i</template>
                        </el-input>
                      </el-form-item>
                    </el-col>
                  </el-row>

                  <el-row :gutter="20">
                    <el-col :span="12">
                      <el-form-item label="工作扭矩" prop="workingTorque">
                        <el-input
                          v-model.number="selectionForm.workingTorque"
                          placeholder="请输入扭矩（可选）"
                        >
                          <template slot="append">N·m</template>
                        </el-input>
                      </el-form-item>
                    </el-col>
                    <el-col :span="12">
                      <el-form-item label="安全系数" prop="safetyFactor">
                        <el-select
                          v-model="selectionForm.safetyFactor"
                          placeholder="请选择"
                          style="width: 100%"
                        >
                          <el-option label="1.0（轻载）" :value="1.0"></el-option>
                          <el-option label="1.25（一般）" :value="1.25"></el-option>
                          <el-option label="1.5（中载）" :value="1.5"></el-option>
                          <el-option label="2.0（重载）" :value="2.0"></el-option>
                        </el-select>
                      </el-form-item>
                    </el-col>
                  </el-row>
                </el-form>
              </div>

              <!-- 步骤 2: 应用条件 -->
              <div v-show="currentStep === 1" class="step-panel">
                <h3>⚙️ 请选择应用条件</h3>
                <el-form
                  ref="conditionForm"
                  :model="selectionForm"
                  label-width="140px"
                  class="selection-form"
                >
                  <el-row :gutter="20">
                    <el-col :span="12">
                      <el-form-item label="安装方式" prop="mountingType">
                        <el-select
                          v-model="selectionForm.mountingType"
                          placeholder="请选择"
                          style="width: 100%"
                        >
                          <el-option label="卧式安装" value="horizontal"></el-option>
                          <el-option label="立式安装" value="vertical"></el-option>
                          <el-option label="悬挂安装" value="suspended"></el-option>
                          <el-option label="法兰安装" value="flange"></el-option>
                        </el-select>
                      </el-form-item>
                    </el-col>
                    <el-col :span="12">
                      <el-form-item label="工作制度" prop="dutyCycle">
                        <el-select
                          v-model="selectionForm.dutyCycle"
                          placeholder="请选择"
                          style="width: 100%"
                        >
                          <el-option label="连续运转" value="continuous"></el-option>
                          <el-option label="间歇运转" value="intermittent"></el-option>
                          <el-option label="短时运转" value="short-time"></el-option>
                        </el-select>
                      </el-form-item>
                    </el-col>
                  </el-row>

                  <el-row :gutter="20">
                    <el-col :span="12">
                      <el-form-item label="工作环境" prop="environment">
                        <el-select
                          v-model="selectionForm.environment"
                          placeholder="请选择"
                          style="width: 100%"
                        >
                          <el-option label="室内常温" value="indoor"></el-option>
                          <el-option label="室外防护" value="outdoor"></el-option>
                          <el-option label="高温环境" value="high-temp"></el-option>
                          <el-option label="低温环境" value="low-temp"></el-option>
                          <el-option label="防爆环境" value="explosion-proof"></el-option>
                        </el-select>
                      </el-form-item>
                    </el-col>
                    <el-col :span="12">
                      <el-form-item label="噪音要求" prop="noiseRequirement">
                        <el-select
                          v-model="selectionForm.noiseRequirement"
                          placeholder="请选择"
                          style="width: 100%"
                        >
                          <el-option label="无要求" value="none"></el-option>
                          <el-option label="低噪音（<75dB）" value="low"></el-option>
                          <el-option label="超低噪音（<65dB）" value="ultra-low"></el-option>
                        </el-select>
                      </el-form-item>
                    </el-col>
                  </el-row>

                  <el-row :gutter="20">
                    <el-col :span="24">
                      <el-form-item label="应用场景">
                        <el-input
                          v-model="selectionForm.application"
                          type="textarea"
                          :rows="3"
                          placeholder="请描述应用场景，如：输送带、搅拌机、提升机等"
                        ></el-input>
                      </el-form-item>
                    </el-col>
                  </el-row>
                </el-form>
              </div>

              <!-- 步骤 3: 智能推荐 -->
              <div v-show="currentStep === 2" class="step-panel">
                <h3>🌟 智能推荐方案</h3>
                <el-alert
                  v-if="recommendedGearboxes.length === 0"
                  title="未找到合适的齿轮箱型号"
                  type="warning"
                  :closable="false"
                  show-icon
                  style="margin-bottom: 20px"
                >
                  请调整选型参数或联系技术支持
                </el-alert>

                <el-row :gutter="20" v-if="recommendedGearboxes.length > 0">
                  <el-col
                    :xs="24"
                    :sm="12"
                    :md="8"
                    v-for="(item, index) in recommendedGearboxes"
                    :key="item.id"
                  >
                    <div
                      class="recommendation-card"
                      :class="{ selected: selectedGearbox && selectedGearbox.id === item.id }"
                      @click="selectGearbox(item)"
                    >
                      <div class="recommendation-badge" v-if="index === 0">
                        <i class="el-icon-trophy"></i> 最佳匹配
                      </div>
                      <div class="recommendation-badge economic" v-else-if="index === 1">
                        <i class="el-icon-coin"></i> 经济方案
                      </div>
                      <div class="recommendation-badge performance" v-else>
                        <i class="el-icon-lightning"></i> 高性能
                      </div>

                      <div class="gearbox-info">
                        <h4>{{ item.model }}</h4>
                        <p class="type-name">{{ item.typeName }}</p>

                        <div class="params">
                          <div class="param-item">
                            <span class="label">减速比：</span>
                            <span class="value">{{ item.reductionRatio }}:1</span>
                          </div>
                          <div class="param-item">
                            <span class="label">额定功率：</span>
                            <span class="value">{{ item.ratedPower }} kW</span>
                          </div>
                          <div class="param-item">
                            <span class="label">额定扭矩：</span>
                            <span class="value">{{ item.ratedTorque }} N·m</span>
                          </div>
                          <div class="param-item">
                            <span class="label">效率：</span>
                            <span class="value">{{ item.efficiency }}%</span>
                          </div>
                          <div class="param-item">
                            <span class="label">噪音：</span>
                            <span class="value">{{ item.noise }} dB</span>
                          </div>
                        </div>

                        <div class="price-stock">
                          <div class="price">
                            <span class="label">参考价格：</span>
                            <span class="value">¥{{ item.price.toLocaleString() }}</span>
                          </div>
                          <div class="stock" :class="item.stock > 0 ? 'in-stock' : 'out-stock'">
                            {{ item.stock > 0 ? `库存：${item.stock}台` : '需订货' }}
                          </div>
                        </div>

                        <div class="match-score">
                          <span>匹配度：</span>
                          <el-progress
                            :percentage="item.matchScore"
                            :color="getScoreColor(item.matchScore)"
                          ></el-progress>
                        </div>
                      </div>

                      <div class="select-icon" v-if="selectedGearbox && selectedGearbox.id === item.id">
                        <i class="el-icon-success"></i>
                      </div>
                    </div>
                  </el-col>
                </el-row>
              </div>

              <!-- 步骤 4: 确认下单 -->
              <div v-show="currentStep === 3" class="step-panel">
                <h3>✅ 确认选型结果</h3>
                <div class="confirmation-content" v-if="selectedGearbox">
                  <el-descriptions :column="2" border>
                    <el-descriptions-item label="选定型号">
                      <span class="highlight">{{ selectedGearbox.model }}</span>
                    </el-descriptions-item>
                    <el-descriptions-item label="类型">
                      {{ selectedGearbox.typeName }}
                    </el-descriptions-item>
                    <el-descriptions-item label="减速比">
                      {{ selectedGearbox.reductionRatio }}:1
                    </el-descriptions-item>
                    <el-descriptions-item label="额定功率">
                      {{ selectedGearbox.ratedPower }} kW
                    </el-descriptions-item>
                    <el-descriptions-item label="额定扭矩">
                      {{ selectedGearbox.ratedTorque }} N·m
                    </el-descriptions-item>
                    <el-descriptions-item label="效率">
                      {{ selectedGearbox.efficiency }}%
                    </el-descriptions-item>
                    <el-descriptions-item label="噪音">
                      {{ selectedGearbox.noise }} dB
                    </el-descriptions-item>
                    <el-descriptions-item label="参考价格">
                      <span class="price-highlight">¥{{ selectedGearbox.price.toLocaleString() }}</span>
                    </el-descriptions-item>
                  </el-descriptions>

                  <el-divider></el-divider>

                  <el-form
                    ref="orderForm"
                    :model="orderForm"
                    :rules="orderRules"
                    label-width="120px"
                  >
                    <el-row :gutter="20">
                      <el-col :span="12">
                        <el-form-item label="客户名称" prop="customerName">
                          <el-input v-model="orderForm.customerName" placeholder="请输入客户名称"></el-input>
                        </el-form-item>
                      </el-col>
                      <el-col :span="12">
                        <el-form-item label="联系电话" prop="contactPhone">
                          <el-input v-model="orderForm.contactPhone" placeholder="请输入联系电话"></el-input>
                        </el-form-item>
                      </el-col>
                    </el-row>

                    <el-row :gutter="20">
                      <el-col :span="12">
                        <el-form-item label="订购数量" prop="quantity">
                          <el-input-number
                            v-model="orderForm.quantity"
                            :min="1"
                            :max="100"
                            style="width: 100%"
                          ></el-input-number>
                        </el-form-item>
                      </el-col>
                      <el-col :span="12">
                        <el-form-item label="期望交期" prop="deliveryDate">
                          <el-date-picker
                            v-model="orderForm.deliveryDate"
                            type="date"
                            placeholder="选择日期"
                            style="width: 100%"
                            :picker-options="pickerOptions"
                          ></el-date-picker>
                        </el-form-item>
                      </el-col>
                    </el-row>

                    <el-form-item label="备注">
                      <el-input
                        v-model="orderForm.remarks"
                        type="textarea"
                        :rows="3"
                        placeholder="请输入其他要求或备注"
                      ></el-input>
                    </el-form-item>
                  </el-form>
                </div>
              </div>
            </div>

            <!-- 操作按钮 -->
            <div class="step-actions">
              <el-button v-if="currentStep > 0" @click="prevStep">上一步</el-button>
              <el-button
                v-if="currentStep < 3"
                type="primary"
                @click="nextStep"
                :disabled="!canProceed"
              >
                下一步
              </el-button>
              <el-button
                v-if="currentStep === 3"
                type="success"
                @click="submitSelection"
                :loading="submitLoading"
              >
                保存选型结果
              </el-button>
              <el-button @click="resetSelection">重新选型</el-button>
            </div>
          </div>
        </el-card>
      </el-tab-pane>

      <!-- Tab 2: 型号库 -->
      <el-tab-pane label="📚 型号库" name="library">
        <el-card shadow="hover">
          <!-- 搜索栏 -->
          <el-form :inline="true" class="search-form">
            <el-form-item>
              <el-input
                v-model="librarySearch.keyword"
                placeholder="搜索型号或类型"
                prefix-icon="el-icon-search"
                clearable
                @clear="loadGearboxLibrary"
              ></el-input>
            </el-form-item>
            <el-form-item>
              <el-select
                v-model="librarySearch.type"
                placeholder="齿轮箱类型"
                clearable
                style="width: 150px"
              >
                <el-option label="全部类型" value=""></el-option>
                <el-option label="斜齿轮减速机" value="helical"></el-option>
                <el-option label="蜗轮蜗杆减速机" value="worm"></el-option>
                <el-option label="行星减速机" value="planetary"></el-option>
                <el-option label="摆线针轮减速机" value="cycloidal"></el-option>
              </el-select>
            </el-form-item>
            <el-form-item>
              <el-button type="primary" @click="loadGearboxLibrary">查询</el-button>
              <el-button @click="resetLibrarySearch">重置</el-button>
              <el-button type="success" icon="el-icon-plus" @click="showAddGearboxDialog">
                添加型号
              </el-button>
            </el-form-item>
          </el-form>

          <!-- 型号列表 -->
          <el-table
            :data="filteredGearboxLibrary"
            border
            stripe
            style="width: 100%"
            v-loading="libraryLoading"
          >
            <el-table-column prop="model" label="型号" width="120" fixed></el-table-column>
            <el-table-column prop="typeName" label="类型" width="140"></el-table-column>
            <el-table-column prop="reductionRatio" label="减速比" width="100">
              <template slot-scope="scope">
                {{ scope.row.reductionRatio }}:1
              </template>
            </el-table-column>
            <el-table-column prop="ratedPower" label="额定功率" width="110">
              <template slot-scope="scope">
                {{ scope.row.ratedPower }} kW
              </template>
            </el-table-column>
            <el-table-column prop="ratedTorque" label="额定扭矩" width="110">
              <template slot-scope="scope">
                {{ scope.row.ratedTorque }} N·m
              </template>
            </el-table-column>
            <el-table-column prop="efficiency" label="效率" width="80">
              <template slot-scope="scope">
                {{ scope.row.efficiency }}%
              </template>
            </el-table-column>
            <el-table-column prop="noise" label="噪音" width="80">
              <template slot-scope="scope">
                {{ scope.row.noise }} dB
              </template>
            </el-table-column>
            <el-table-column prop="price" label="参考价格" width="110">
              <template slot-scope="scope">
                ¥{{ scope.row.price.toLocaleString() }}
              </template>
            </el-table-column>
            <el-table-column prop="stock" label="库存" width="80">
              <template slot-scope="scope">
                <span :class="scope.row.stock > 0 ? 'stock-normal' : 'stock-out'">
                  {{ scope.row.stock }}
                </span>
              </template>
            </el-table-column>
            <el-table-column label="操作" width="160" fixed="right">
              <template slot-scope="scope">
                <el-button type="text" size="small" @click="viewGearboxDetail(scope.row)">
                  详情
                </el-button>
                <el-button type="text" size="small" @click="editGearbox(scope.row)">
                  编辑
                </el-button>
                <el-button
                  type="text"
                  size="small"
                  class="danger-text"
                  @click="deleteGearbox(scope.row)"
                >
                  删除
                </el-button>
              </template>
            </el-table-column>
          </el-table>

          <!-- 分页 -->
          <el-pagination
            @size-change="handleLibrarySizeChange"
            @current-change="handleLibraryCurrentChange"
            :current-page="libraryPagination.page"
            :page-sizes="[10, 20, 50, 100]"
            :page-size="libraryPagination.size"
            layout="total, sizes, prev, pager, next, jumper"
            :total="gearboxLibrary.length"
            style="margin-top: 20px; text-align: right"
          >
          </el-pagination>
        </el-card>
      </el-tab-pane>

      <!-- Tab 3: 选型历史 -->
      <el-tab-pane label="📋 选型历史" name="history">
        <el-card shadow="hover">
          <!-- 搜索栏 -->
          <el-form :inline="true" class="search-form">
            <el-form-item>
              <el-input
                v-model="historySearch.keyword"
                placeholder="搜索客户或型号"
                prefix-icon="el-icon-search"
                clearable
              ></el-input>
            </el-form-item>
            <el-form-item>
              <el-date-picker
                v-model="historySearch.dateRange"
                type="daterange"
                range-separator="至"
                start-placeholder="开始日期"
                end-placeholder="结束日期"
              ></el-date-picker>
            </el-form-item>
            <el-form-item>
              <el-button type="primary" @click="loadSelectionHistory">查询</el-button>
              <el-button @click="resetHistorySearch">重置</el-button>
            </el-form-item>
          </el-form>

          <!-- 历史记录列表 -->
          <el-table
            :data="filteredSelectionHistory"
            border
            stripe
            style="width: 100%"
          >
            <el-table-column type="expand">
              <template slot-scope="scope">
                <div class="expand-content">
                  <el-descriptions :column="2" border size="small">
                    <el-descriptions-item label="电机功率">
                      {{ scope.row.motorPower }} kW
                    </el-descriptions-item>
                    <el-descriptions-item label="电机转速">
                      {{ scope.row.motorSpeed }} rpm
                    </el-descriptions-item>
                    <el-descriptions-item label="输出转速">
                      {{ scope.row.outputSpeed }} rpm
                    </el-descriptions-item>
                    <el-descriptions-item label="减速比">
                      {{ scope.row.reductionRatio }}:1
                    </el-descriptions-item>
                    <el-descriptions-item label="安装方式">
                      {{ getMountingTypeName(scope.row.mountingType) }}
                    </el-descriptions-item>
                    <el-descriptions-item label="工作环境">
                      {{ getEnvironmentName(scope.row.environment) }}
                    </el-descriptions-item>
                    <el-descriptions-item label="应用场景" :span="2">
                      {{ scope.row.application || '-' }}
                    </el-descriptions-item>
                    <el-descriptions-item label="备注" :span="2">
                      {{ scope.row.remarks || '-' }}
                    </el-descriptions-item>
                  </el-descriptions>
                </div>
              </template>
            </el-table-column>
            <el-table-column prop="selectionNo" label="选型编号" width="140"></el-table-column>
            <el-table-column prop="customerName" label="客户名称" width="150"></el-table-column>
            <el-table-column prop="selectedModel" label="选定型号" width="120"></el-table-column>
            <el-table-column prop="quantity" label="数量" width="80"></el-table-column>
            <el-table-column prop="totalPrice" label="总价" width="110">
              <template slot-scope="scope">
                ¥{{ (scope.row.totalPrice || 0).toLocaleString() }}
              </template>
            </el-table-column>
            <el-table-column prop="createTime" label="选型时间" width="160"></el-table-column>
            <el-table-column label="操作" width="200" fixed="right">
              <template slot-scope="scope">
                <el-button type="text" size="small" @click="viewHistoryDetail(scope.row)">
                  详情
                </el-button>
                <el-button type="text" size="small" @click="reselect(scope.row)">
                  重新选型
                </el-button>
                <el-button type="text" size="small" @click="exportPDF(scope.row)">
                  导出PDF
                </el-button>
              </template>
            </el-table-column>
          </el-table>

          <!-- 分页 -->
          <el-pagination
            @size-change="handleHistorySizeChange"
            @current-change="handleHistoryCurrentChange"
            :current-page="historyPagination.page"
            :page-sizes="[10, 20, 50, 100]"
            :page-size="historyPagination.size"
            layout="total, sizes, prev, pager, next, jumper"
            :total="selectionHistory.length"
            style="margin-top: 20px; text-align: right"
          >
          </el-pagination>
        </el-card>
      </el-tab-pane>
    </el-tabs>

    <!-- 添加/编辑齿轮箱对话框 -->
    <el-dialog
      :title="gearboxDialogMode === 'add' ? '添加齿轮箱型号' : '编辑齿轮箱型号'"
      :visible.sync="gearboxDialogVisible"
      width="800px"
      @close="resetGearboxForm"
    >
      <el-form
        ref="gearboxForm"
        :model="gearboxForm"
        :rules="gearboxRules"
        label-width="120px"
      >
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="型号" prop="model">
              <el-input v-model="gearboxForm.model" placeholder="如：SEW-R87"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="类型" prop="type">
              <el-select v-model="gearboxForm.type" placeholder="请选择" style="width: 100%">
                <el-option label="斜齿轮减速机" value="helical"></el-option>
                <el-option label="蜗轮蜗杆减速机" value="worm"></el-option>
                <el-option label="行星减速机" value="planetary"></el-option>
                <el-option label="摆线针轮减速机" value="cycloidal"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="减速比" prop="reductionRatio">
              <el-input v-model.number="gearboxForm.reductionRatio" placeholder="如：10">
                <template slot="append">:1</template>
              </el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="额定功率" prop="ratedPower">
              <el-input v-model.number="gearboxForm.ratedPower" placeholder="如：7.5">
                <template slot="append">kW</template>
              </el-input>
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="额定扭矩" prop="ratedTorque">
              <el-input v-model.number="gearboxForm.ratedTorque" placeholder="如：500">
                <template slot="append">N·m</template>
              </el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="效率" prop="efficiency">
              <el-input v-model.number="gearboxForm.efficiency" placeholder="如：94">
                <template slot="append">%</template>
              </el-input>
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="噪音" prop="noise">
              <el-input v-model.number="gearboxForm.noise" placeholder="如：68">
                <template slot="append">dB</template>
              </el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="参考价格" prop="price">
              <el-input v-model.number="gearboxForm.price" placeholder="如：8500">
                <template slot="prepend">¥</template>
              </el-input>
            </el-form-item>
          </el-col>
        </el-row>

        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="库存数量" prop="stock">
              <el-input-number
                v-model="gearboxForm.stock"
                :min="0"
                :max="9999"
                style="width: 100%"
              ></el-input-number>
            </el-form-item>
          </el-col>
        </el-row>

        <el-form-item label="备注">
          <el-input
            v-model="gearboxForm.remarks"
            type="textarea"
            :rows="3"
            placeholder="请输入备注信息"
          ></el-input>
        </el-form-item>
      </el-form>

      <span slot="footer">
        <el-button @click="gearboxDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitGearboxForm" :loading="gearboxDialogLoading">
          确定
        </el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'GearboxSelection',
  data() {
    return {
      // 当前Tab
      activeTab: 'selection',

      // 选型步骤
      currentStep: 0,

      // 选型表单
      selectionForm: {
        motorPower: null,
        motorSpeed: 1450,
        outputSpeed: null,
        workingTorque: null,
        safetyFactor: 1.25,
        mountingType: 'horizontal',
        dutyCycle: 'continuous',
        environment: 'indoor',
        noiseRequirement: 'none',
        application: ''
      },

      // 选型表单验证
      selectionRules: {
        motorPower: [
          { required: true, message: '请输入电机功率', trigger: 'blur' },
          { type: 'number', min: 0.1, max: 1000, message: '功率范围：0.1-1000 kW', trigger: 'blur' }
        ],
        motorSpeed: [
          { required: true, message: '请输入电机转速', trigger: 'blur' },
          { type: 'number', min: 1, max: 10000, message: '转速范围：1-10000 rpm', trigger: 'blur' }
        ],
        outputSpeed: [
          { required: true, message: '请输入输出转速', trigger: 'blur' },
          { type: 'number', min: 1, max: 10000, message: '转速范围：1-10000 rpm', trigger: 'blur' }
        ],
        safetyFactor: [
          { required: true, message: '请选择安全系数', trigger: 'change' }
        ]
      },

      // 推荐的齿轮箱列表
      recommendedGearboxes: [],

      // 选中的齿轮箱
      selectedGearbox: null,

      // 订单表单
      orderForm: {
        customerName: '',
        contactPhone: '',
        quantity: 1,
        deliveryDate: '',
        remarks: ''
      },

      // 订单表单验证
      orderRules: {
        customerName: [
          { required: true, message: '请输入客户名称', trigger: 'blur' }
        ],
        contactPhone: [
          { required: true, message: '请输入联系电话', trigger: 'blur' },
          { pattern: /^1[3-9]\d{9}$/, message: '请输入有效的手机号', trigger: 'blur' }
        ],
        quantity: [
          { required: true, message: '请输入订购数量', trigger: 'blur' }
        ],
        deliveryDate: [
          { required: true, message: '请选择期望交期', trigger: 'change' }
        ]
      },

      // 日期选择器配置
      pickerOptions: {
        disabledDate(time) {
          return time.getTime() < Date.now() - 8.64e7;
        }
      },

      // 提交加载状态
      submitLoading: false,

      // 齿轮箱型号库
      gearboxLibrary: [],
      filteredGearboxLibrary: [],
      libraryLoading: false,
      librarySearch: {
        keyword: '',
        type: ''
      },
      libraryPagination: {
        page: 1,
        size: 10
      },

      // 选型历史
      selectionHistory: [],
      filteredSelectionHistory: [],
      historySearch: {
        keyword: '',
        dateRange: []
      },
      historyPagination: {
        page: 1,
        size: 10
      },

      // 齿轮箱对话框
      gearboxDialogVisible: false,
      gearboxDialogMode: 'add',
      gearboxDialogLoading: false,
      gearboxForm: {
        model: '',
        type: '',
        reductionRatio: null,
        ratedPower: null,
        ratedTorque: null,
        efficiency: null,
        noise: null,
        price: null,
        stock: 0,
        remarks: ''
      },
      gearboxRules: {
        model: [{ required: true, message: '请输入型号', trigger: 'blur' }],
        type: [{ required: true, message: '请选择类型', trigger: 'change' }],
        reductionRatio: [
          { required: true, message: '请输入减速比', trigger: 'blur' },
          { type: 'number', min: 1, max: 10000, message: '减速比范围：1-10000', trigger: 'blur' }
        ],
        ratedPower: [
          { required: true, message: '请输入额定功率', trigger: 'blur' },
          { type: 'number', min: 0.1, max: 1000, message: '功率范围：0.1-1000 kW', trigger: 'blur' }
        ],
        ratedTorque: [
          { required: true, message: '请输入额定扭矩', trigger: 'blur' },
          { type: 'number', min: 1, max: 1000000, message: '扭矩范围：1-1000000 N·m', trigger: 'blur' }
        ],
        efficiency: [
          { required: true, message: '请输入效率', trigger: 'blur' },
          { type: 'number', min: 1, max: 100, message: '效率范围：1-100%', trigger: 'blur' }
        ],
        noise: [
          { required: true, message: '请输入噪音', trigger: 'blur' },
          { type: 'number', min: 30, max: 120, message: '噪音范围：30-120 dB', trigger: 'blur' }
        ],
        price: [
          { required: true, message: '请输入参考价格', trigger: 'blur' },
          { type: 'number', min: 0, max: 9999999, message: '价格范围：0-9999999', trigger: 'blur' }
        ]
      }
    };
  },

  computed: {
    // 计算减速比
    reductionRatio() {
      if (this.selectionForm.motorSpeed && this.selectionForm.outputSpeed) {
        const ratio = this.selectionForm.motorSpeed / this.selectionForm.outputSpeed;
        return ratio.toFixed(2);
      }
      return '';
    },

    // 是否可以进入下一步
    canProceed() {
      if (this.currentStep === 0) {
        return this.selectionForm.motorPower &&
               this.selectionForm.motorSpeed &&
               this.selectionForm.outputSpeed;
      } else if (this.currentStep === 1) {
        return this.selectionForm.mountingType &&
               this.selectionForm.dutyCycle &&
               this.selectionForm.environment;
      } else if (this.currentStep === 2) {
        return this.selectedGearbox !== null;
      }
      return true;
    },

    // 选型成功率
    successRate() {
      if (this.selectionHistory.length === 0) return 0;
      return 95;
    },

    // 热门型号
    popularModel() {
      if (this.selectionHistory.length === 0) return '-';
      return 'SEW-R87';
    }
  },

  created() {
    this.loadGearboxLibrary();
    this.loadSelectionHistory();
  },

  methods: {
    // 计算减速比
    calculateReductionRatio() {
      // 自动计算，使用computed
    },

    // 上一步
    prevStep() {
      if (this.currentStep > 0) {
        this.currentStep--;
      }
    },

    // 下一步
    async nextStep() {
      if (this.currentStep === 0) {
        // 验证基础参数表单
        const valid = await this.$refs.basicForm.validate().catch(() => false);
        if (!valid) return;
      }

      if (this.currentStep === 1) {
        // 进入推荐步骤，执行智能推荐
        this.performRecommendation();
      }

      if (this.currentStep < 3) {
        this.currentStep++;
      }
    },

    // 执行智能推荐
    performRecommendation() {
      const targetRatio = parseFloat(this.reductionRatio);
      const motorPower = this.selectionForm.motorPower;

      // 从型号库中筛选合适的齿轮箱
      let candidates = this.gearboxLibrary.filter(item => {
        // 减速比匹配（误差±20%）
        const ratioMatch = Math.abs(item.reductionRatio - targetRatio) / targetRatio <= 0.2;
        // 功率匹配（≥电机功率）
        const powerMatch = item.ratedPower >= motorPower;

        return ratioMatch && powerMatch;
      });

      // 计算匹配度
      candidates = candidates.map(item => {
        // 减速比匹配度（0-40分）
        const ratioDiff = Math.abs(item.reductionRatio - targetRatio) / targetRatio;
        const ratioScore = Math.max(0, 40 - ratioDiff * 100);

        // 功率匹配度（0-30分）
        const powerDiff = Math.abs(item.ratedPower - motorPower) / motorPower;
        const powerScore = Math.max(0, 30 - powerDiff * 50);

        // 效率分数（0-15分）
        const efficiencyScore = (item.efficiency - 70) / 30 * 15;

        // 噪音分数（0-15分）
        const noiseScore = Math.max(0, 15 - (item.noise - 60) / 10 * 15);

        const matchScore = Math.round(ratioScore + powerScore + efficiencyScore + noiseScore);

        return {
          ...item,
          matchScore: Math.min(100, matchScore)
        };
      });

      // 按匹配度排序
      candidates.sort((a, b) => b.matchScore - a.matchScore);

      // 取前3个
      this.recommendedGearboxes = candidates.slice(0, 3);

      if (this.recommendedGearboxes.length === 0) {
        this.$message.warning('未找到合适的齿轮箱型号，请调整参数或联系技术支持');
      }
    },

    // 选择齿轮箱
    selectGearbox(gearbox) {
      this.selectedGearbox = gearbox;
    },

    // 获取匹配度颜色
    getScoreColor(score) {
      if (score >= 90) return '#67C23A';
      if (score >= 75) return '#E6A23C';
      return '#F56C6C';
    },

    // 提交选型结果
    submitSelection() {
      this.$refs.orderForm.validate(async (valid) => {
        if (!valid) return;

        try {
          this.submitLoading = true;

          // 生成选型编号
          const selectionNo = 'SEL' + Date.now().toString().slice(-10);

          // 准备数据
          const selectionData = {
            selectionNo,
            ...this.selectionForm,
            selectedModel: this.selectedGearbox.model,
            selectedGearboxId: this.selectedGearbox.id,
            reductionRatio: this.reductionRatio,
            ...this.orderForm,
            totalPrice: this.selectedGearbox.price * this.orderForm.quantity,
            createTime: new Date().toLocaleString('zh-CN', {
              year: 'numeric',
              month: '2-digit',
              day: '2-digit',
              hour: '2-digit',
              minute: '2-digit',
              second: '2-digit',
              hour12: false
            })
          };

          // 调用API（生产环境）
          // await axios.post('/api/gearbox/selection', selectionData);

          // 保存到历史记录（开发环境）
          this.selectionHistory.unshift(selectionData);

          this.$message.success('选型结果已保存');

          // 切换到历史记录Tab
          this.activeTab = 'history';

          // 重置选型
          this.resetSelection();

        } catch (error) {
          this.$message.error('保存失败：' + error.message);
        } finally {
          this.submitLoading = false;
        }
      });
    },

    // 重置选型
    resetSelection() {
      this.currentStep = 0;
      this.selectionForm = {
        motorPower: null,
        motorSpeed: 1450,
        outputSpeed: null,
        workingTorque: null,
        safetyFactor: 1.25,
        mountingType: 'horizontal',
        dutyCycle: 'continuous',
        environment: 'indoor',
        noiseRequirement: 'none',
        application: ''
      };
      this.recommendedGearboxes = [];
      this.selectedGearbox = null;
      this.orderForm = {
        customerName: '',
        contactPhone: '',
        quantity: 1,
        deliveryDate: '',
        remarks: ''
      };

      // 清空验证
      this.$nextTick(() => {
        if (this.$refs.basicForm) this.$refs.basicForm.clearValidate();
        if (this.$refs.orderForm) this.$refs.orderForm.clearValidate();
      });
    },

    // 加载齿轮箱型号库
    async loadGearboxLibrary() {
      try {
        this.libraryLoading = true;

        // 调用API（生产环境）
        // const res = await axios.get('/api/gearbox/library', {
        //   params: this.librarySearch
        // });
        // this.gearboxLibrary = res.data.list;

        // 使用模拟数据（开发环境）
        if (this.gearboxLibrary.length === 0) {
          this.gearboxLibrary = this.mockGearboxLibrary();
        }

        // 筛选
        this.filterGearboxLibrary();

      } catch (error) {
        this.$message.error('加载失败：' + error.message);
      } finally {
        this.libraryLoading = false;
      }
    },

    // 筛选型号库
    filterGearboxLibrary() {
      let result = [...this.gearboxLibrary];

      // 关键词搜索
      if (this.librarySearch.keyword) {
        const kw = this.librarySearch.keyword.toLowerCase();
        result = result.filter(item =>
          item.model.toLowerCase().includes(kw) ||
          item.typeName.toLowerCase().includes(kw)
        );
      }

      // 类型筛选
      if (this.librarySearch.type) {
        result = result.filter(item => item.type === this.librarySearch.type);
      }

      this.filteredGearboxLibrary = result;
    },

    // 重置型号库搜索
    resetLibrarySearch() {
      this.librarySearch = {
        keyword: '',
        type: ''
      };
      this.loadGearboxLibrary();
    },

    // 显示添加齿轮箱对话框
    showAddGearboxDialog() {
      this.gearboxDialogMode = 'add';
      this.gearboxDialogVisible = true;
    },

    // 编辑齿轮箱
    editGearbox(row) {
      this.gearboxDialogMode = 'edit';
      this.gearboxForm = { ...row };
      this.gearboxDialogVisible = true;
    },

    // 查看齿轮箱详情
    viewGearboxDetail(row) {
      this.$alert(
        `<div style="text-align: left;">
          <p><strong>型号：</strong>${row.model}</p>
          <p><strong>类型：</strong>${row.typeName}</p>
          <p><strong>减速比：</strong>${row.reductionRatio}:1</p>
          <p><strong>额定功率：</strong>${row.ratedPower} kW</p>
          <p><strong>额定扭矩：</strong>${row.ratedTorque} N·m</p>
          <p><strong>效率：</strong>${row.efficiency}%</p>
          <p><strong>噪音：</strong>${row.noise} dB</p>
          <p><strong>参考价格：</strong>¥${row.price.toLocaleString()}</p>
          <p><strong>库存：</strong>${row.stock}台</p>
          ${row.remarks ? `<p><strong>备注：</strong>${row.remarks}</p>` : ''}
        </div>`,
        '齿轮箱详情',
        {
          dangerouslyUseHTMLString: true,
          confirmButtonText: '关闭'
        }
      );
    },

    // 删除齿轮箱
    deleteGearbox(row) {
      this.$confirm(`确定要删除型号【${row.model}】吗？`, '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(async () => {
        try {
          // 调用API（生产环境）
          // await axios.delete(`/api/gearbox/${row.id}`);

          // 删除本地数据（开发环境）
          const index = this.gearboxLibrary.findIndex(item => item.id === row.id);
          if (index > -1) {
            this.gearboxLibrary.splice(index, 1);
          }

          this.$message.success('删除成功');
          this.loadGearboxLibrary();

        } catch (error) {
          this.$message.error('删除失败：' + error.message);
        }
      }).catch(() => {});
    },

    // 提交齿轮箱表单
    submitGearboxForm() {
      this.$refs.gearboxForm.validate(async (valid) => {
        if (!valid) return;

        try {
          this.gearboxDialogLoading = true;

          const typeNames = {
            helical: '斜齿轮减速机',
            worm: '蜗轮蜗杆减速机',
            planetary: '行星减速机',
            cycloidal: '摆线针轮减速机'
          };

          const gearboxData = {
            ...this.gearboxForm,
            typeName: typeNames[this.gearboxForm.type]
          };

          if (this.gearboxDialogMode === 'add') {
            // 调用API（生产环境）
            // await axios.post('/api/gearbox', gearboxData);

            // 添加到本地数据（开发环境）
            gearboxData.id = Date.now();
            this.gearboxLibrary.unshift(gearboxData);

            this.$message.success('添加成功');
          } else {
            // 调用API（生产环境）
            // await axios.put(`/api/gearbox/${gearboxData.id}`, gearboxData);

            // 更新本地数据（开发环境）
            const index = this.gearboxLibrary.findIndex(item => item.id === gearboxData.id);
            if (index > -1) {
              this.$set(this.gearboxLibrary, index, gearboxData);
            }

            this.$message.success('修改成功');
          }

          this.gearboxDialogVisible = false;
          this.loadGearboxLibrary();

        } catch (error) {
          this.$message.error('操作失败：' + error.message);
        } finally {
          this.gearboxDialogLoading = false;
        }
      });
    },

    // 重置齿轮箱表单
    resetGearboxForm() {
      this.gearboxForm = {
        model: '',
        type: '',
        reductionRatio: null,
        ratedPower: null,
        ratedTorque: null,
        efficiency: null,
        noise: null,
        price: null,
        stock: 0,
        remarks: ''
      };
      this.$nextTick(() => {
        if (this.$refs.gearboxForm) {
          this.$refs.gearboxForm.clearValidate();
        }
      });
    },

    // 加载选型历史
    async loadSelectionHistory() {
      try {
        // 调用API（生产环境）
        // const res = await axios.get('/api/gearbox/selection/history', {
        //   params: this.historySearch
        // });
        // this.selectionHistory = res.data.list;

        // 使用模拟数据（开发环境）
        if (this.selectionHistory.length === 0) {
          this.selectionHistory = this.mockSelectionHistory();
        }

        // 筛选
        this.filterSelectionHistory();

      } catch (error) {
        this.$message.error('加载失败：' + error.message);
      }
    },

    // 筛选选型历史
    filterSelectionHistory() {
      let result = [...this.selectionHistory];

      // 关键词搜索
      if (this.historySearch.keyword) {
        const kw = this.historySearch.keyword.toLowerCase();
        result = result.filter(item =>
          item.customerName.toLowerCase().includes(kw) ||
          item.selectedModel.toLowerCase().includes(kw) ||
          item.selectionNo.toLowerCase().includes(kw)
        );
      }

      // 日期筛选
      if (this.historySearch.dateRange && this.historySearch.dateRange.length === 2) {
        const [start, end] = this.historySearch.dateRange;
        result = result.filter(item => {
          const itemDate = new Date(item.createTime);
          return itemDate >= start && itemDate <= end;
        });
      }

      this.filteredSelectionHistory = result;
    },

    // 重置历史搜索
    resetHistorySearch() {
      this.historySearch = {
        keyword: '',
        dateRange: []
      };
      this.loadSelectionHistory();
    },

    // 查看历史详情
    viewHistoryDetail(row) {
      this.$alert(
        `<div style="text-align: left; max-height: 400px; overflow-y: auto;">
          <h4 style="margin-top: 0;">选型信息</h4>
          <p><strong>选型编号：</strong>${row.selectionNo}</p>
          <p><strong>客户名称：</strong>${row.customerName}</p>
          <p><strong>联系电话：</strong>${row.contactPhone}</p>
          <p><strong>选定型号：</strong>${row.selectedModel}</p>
          <p><strong>订购数量：</strong>${row.quantity}台</p>
          <p><strong>总价：</strong>¥${(row.totalPrice || 0).toLocaleString()}</p>
          <p><strong>期望交期：</strong>${row.deliveryDate}</p>

          <h4>技术参数</h4>
          <p><strong>电机功率：</strong>${row.motorPower} kW</p>
          <p><strong>电机转速：</strong>${row.motorSpeed} rpm</p>
          <p><strong>输出转速：</strong>${row.outputSpeed} rpm</p>
          <p><strong>减速比：</strong>${row.reductionRatio}:1</p>
          <p><strong>安装方式：</strong>${this.getMountingTypeName(row.mountingType)}</p>
          <p><strong>工作环境：</strong>${this.getEnvironmentName(row.environment)}</p>

          ${row.application ? `<p><strong>应用场景：</strong>${row.application}</p>` : ''}
          ${row.remarks ? `<p><strong>备注：</strong>${row.remarks}</p>` : ''}

          <p><strong>选型时间：</strong>${row.createTime}</p>
        </div>`,
        '选型详情',
        {
          dangerouslyUseHTMLString: true,
          confirmButtonText: '关闭'
        }
      );
    },

    // 重新选型
    reselect(row) {
      this.selectionForm = {
        motorPower: row.motorPower,
        motorSpeed: row.motorSpeed,
        outputSpeed: row.outputSpeed,
        workingTorque: row.workingTorque,
        safetyFactor: row.safetyFactor,
        mountingType: row.mountingType,
        dutyCycle: row.dutyCycle,
        environment: row.environment,
        noiseRequirement: row.noiseRequirement,
        application: row.application
      };
      this.currentStep = 0;
      this.activeTab = 'selection';
      this.$message.info('已加载历史参数，请重新选型');
    },

    // 导出PDF
    exportPDF(row) {
      this.$message.info('PDF导出功能开发中...');
      // 实际项目中可以使用 jsPDF 或服务端生成PDF
    },

    // 获取安装方式名称
    getMountingTypeName(type) {
      const map = {
        horizontal: '卧式安装',
        vertical: '立式安装',
        suspended: '悬挂安装',
        flange: '法兰安装'
      };
      return map[type] || type;
    },

    // 获取工作环境名称
    getEnvironmentName(env) {
      const map = {
        indoor: '室内常温',
        outdoor: '室外防护',
        'high-temp': '高温环境',
        'low-temp': '低温环境',
        'explosion-proof': '防爆环境'
      };
      return map[env] || env;
    },

    // 分页处理
    handleLibrarySizeChange(val) {
      this.libraryPagination.size = val;
      this.loadGearboxLibrary();
    },
    handleLibraryCurrentChange(val) {
      this.libraryPagination.page = val;
    },
    handleHistorySizeChange(val) {
      this.historyPagination.size = val;
      this.loadSelectionHistory();
    },
    handleHistoryCurrentChange(val) {
      this.historyPagination.page = val;
    },

    // ===== 模拟数据 =====
    mockGearboxLibrary() {
      return [
        {
          id: 1,
          model: 'SEW-R87',
          type: 'helical',
          typeName: '斜齿轮减速机',
          reductionRatio: 9.86,
          ratedPower: 7.5,
          ratedTorque: 500,
          efficiency: 94,
          noise: 68,
          price: 8500,
          stock: 5
        },
        {
          id: 2,
          model: 'SEW-F87',
          type: 'helical',
          typeName: '斜齿轮减速机',
          reductionRatio: 14.83,
          ratedPower: 11,
          ratedTorque: 850,
          efficiency: 95,
          noise: 70,
          price: 12000,
          stock: 3
        },
        {
          id: 3,
          model: 'NORD-SK9032',
          type: 'helical',
          typeName: '斜齿轮减速机',
          reductionRatio: 19.53,
          ratedPower: 15,
          ratedTorque: 1200,
          efficiency: 96,
          noise: 72,
          price: 16800,
          stock: 2
        },
        {
          id: 4,
          model: 'WPA-80',
          type: 'worm',
          typeName: '蜗轮蜗杆减速机',
          reductionRatio: 10,
          ratedPower: 5.5,
          ratedTorque: 450,
          efficiency: 85,
          noise: 75,
          price: 4500,
          stock: 8
        },
        {
          id: 5,
          model: 'XLD-8',
          type: 'cycloidal',
          typeName: '摆线针轮减速机',
          reductionRatio: 17,
          ratedPower: 7.5,
          ratedTorque: 650,
          efficiency: 92,
          noise: 70,
          price: 6800,
          stock: 4
        },
        {
          id: 6,
          model: 'PLE-160',
          type: 'planetary',
          typeName: '行星减速机',
          reductionRatio: 25,
          ratedPower: 22,
          ratedTorque: 2500,
          efficiency: 97,
          noise: 65,
          price: 28000,
          stock: 1
        },
        {
          id: 7,
          model: 'SEW-R77',
          type: 'helical',
          typeName: '斜齿轮减速机',
          reductionRatio: 7.56,
          ratedPower: 5.5,
          ratedTorque: 380,
          efficiency: 94,
          noise: 66,
          price: 7200,
          stock: 6
        },
        {
          id: 8,
          model: 'NORD-SK7132',
          type: 'helical',
          typeName: '斜齿轮减速机',
          reductionRatio: 12.67,
          ratedPower: 11,
          ratedTorque: 920,
          efficiency: 95,
          noise: 69,
          price: 13500,
          stock: 2
        },
        {
          id: 9,
          model: 'WPA-100',
          type: 'worm',
          typeName: '蜗轮蜗杆减速机',
          reductionRatio: 15,
          ratedPower: 7.5,
          ratedTorque: 600,
          efficiency: 86,
          noise: 76,
          price: 5800,
          stock: 7
        },
        {
          id: 10,
          model: 'XLD-10',
          type: 'cycloidal',
          typeName: '摆线针轮减速机',
          reductionRatio: 23,
          ratedPower: 11,
          ratedTorque: 950,
          efficiency: 93,
          noise: 71,
          price: 8900,
          stock: 3
        }
      ];
    },

    mockSelectionHistory() {
      return [
        {
          id: 1,
          selectionNo: 'SEL1730620800',
          customerName: '华东机械厂',
          contactPhone: '13800138001',
          selectedModel: 'SEW-R87',
          quantity: 2,
          totalPrice: 17000,
          motorPower: 7.5,
          motorSpeed: 1450,
          outputSpeed: 147,
          reductionRatio: '9.86',
          workingTorque: 480,
          safetyFactor: 1.25,
          mountingType: 'horizontal',
          dutyCycle: 'continuous',
          environment: 'indoor',
          noiseRequirement: 'low',
          application: '输送带驱动',
          deliveryDate: '2025-11-15',
          remarks: '需提供安装图纸',
          createTime: '2025-11-01 10:30:00'
        },
        {
          id: 2,
          selectionNo: 'SEL1730621100',
          customerName: '南方化工集团',
          contactPhone: '13900139002',
          selectedModel: 'NORD-SK9032',
          quantity: 1,
          totalPrice: 16800,
          motorPower: 15,
          motorSpeed: 1450,
          outputSpeed: 74,
          reductionRatio: '19.59',
          workingTorque: 1150,
          safetyFactor: 1.5,
          mountingType: 'vertical',
          dutyCycle: 'continuous',
          environment: 'outdoor',
          noiseRequirement: 'ultra-low',
          application: '搅拌机',
          deliveryDate: '2025-11-20',
          remarks: '防护等级IP65',
          createTime: '2025-11-02 14:20:00'
        },
        {
          id: 3,
          selectionNo: 'SEL1730622400',
          customerName: '北方钢铁公司',
          contactPhone: '13700137003',
          selectedModel: 'PLE-160',
          quantity: 3,
          totalPrice: 84000,
          motorPower: 22,
          motorSpeed: 1450,
          outputSpeed: 58,
          reductionRatio: '25.00',
          workingTorque: 2400,
          safetyFactor: 2.0,
          mountingType: 'flange',
          dutyCycle: 'intermittent',
          environment: 'high-temp',
          noiseRequirement: 'low',
          application: '轧机传动',
          deliveryDate: '2025-11-25',
          remarks: '高温型，需特殊润滑',
          createTime: '2025-11-03 09:45:00'
        }
      ];
    }
  }
};
</script>

<style scoped lang="scss">
.gearbox-selection {
  padding: 20px;
  background: #f5f7fa;
  min-height: 100vh;
}

.page-header {
  margin-bottom: 24px;
  text-align: center;

  h2 {
    font-size: 28px;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    margin: 0 0 8px 0;
  }

  .subtitle {
    color: #909399;
    font-size: 14px;
    margin: 0;
  }
}

/* 统计卡片 */
.stats-row {
  margin-bottom: 24px;

  .stats-card {
    background: white;
    border-radius: 12px;
    padding: 20px;
    box-shadow: 0 2px 12px rgba(102, 126, 234, 0.1);
    transition: all 0.3s;

    &:hover {
      transform: translateY(-4px);
      box-shadow: 0 4px 20px rgba(102, 126, 234, 0.15);
    }

    .stats-content {
      display: flex;
      align-items: center;
      gap: 16px;

      .icon-wrapper {
        width: 50px;
        height: 50px;
        border-radius: 12px;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-size: 24px;
        flex-shrink: 0;
      }

      .stats-info {
        flex: 1;

        .value {
          font-size: 28px;
          font-weight: bold;
          background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
          -webkit-background-clip: text;
          -webkit-text-fill-color: transparent;
          margin-bottom: 4px;
        }

        .label {
          font-size: 14px;
          color: #909399;
        }
      }
    }
  }
}

/* Tab样式 */
.main-tabs {
  /deep/ .el-tabs__header {
    background: white;
    padding: 0 20px;
    border-radius: 8px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
  }

  /deep/ .el-tabs__item {
    font-size: 16px;
    padding: 0 24px;
  }

  /deep/ .el-tabs__item.is-active {
    color: #667eea;
  }

  /deep/ .el-tabs__active-bar {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  }
}

/* 选型卡片 */
.selection-card {
  /deep/ .el-card__body {
    padding: 30px;
  }
}

.selection-form-wrapper {
  .el-steps {
    margin-bottom: 40px;
  }

  .step-content {
    min-height: 400px;
    padding: 20px 0;
  }

  .step-panel {
    h3 {
      font-size: 20px;
      color: #303133;
      margin: 0 0 24px 0;
      padding-bottom: 12px;
      border-bottom: 2px solid #667eea;
    }
  }

  .selection-form {
    max-width: 900px;
    margin: 0 auto;
  }

  .step-actions {
    display: flex;
    justify-content: center;
    gap: 16px;
    margin-top: 40px;
    padding-top: 30px;
    border-top: 1px solid #e4e7ed;
  }
}

/* 推荐卡片 */
.recommendation-card {
  position: relative;
  background: white;
  border: 2px solid #e4e7ed;
  border-radius: 12px;
  padding: 20px;
  margin-bottom: 20px;
  cursor: pointer;
  transition: all 0.3s;

  &:hover {
    transform: translateY(-4px);
    box-shadow: 0 4px 20px rgba(102, 126, 234, 0.15);
  }

  &.selected {
    border-color: #667eea;
    background: linear-gradient(135deg, rgba(102, 126, 234, 0.05) 0%, rgba(118, 75, 162, 0.05) 100%);

    .select-icon {
      display: flex;
    }
  }

  .recommendation-badge {
    position: absolute;
    top: -12px;
    right: 20px;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    padding: 4px 12px;
    border-radius: 12px;
    font-size: 12px;
    font-weight: bold;

    &.economic {
      background: linear-gradient(135deg, #E6A23C 0%, #F7BA2A 100%);
    }

    &.performance {
      background: linear-gradient(135deg, #F56C6C 0%, #FF85C0 100%);
    }
  }

  .gearbox-info {
    h4 {
      font-size: 20px;
      color: #303133;
      margin: 8px 0 4px 0;
    }

    .type-name {
      font-size: 14px;
      color: #909399;
      margin: 0 0 16px 0;
    }

    .params {
      margin: 16px 0;
      padding: 16px 0;
      border-top: 1px solid #e4e7ed;
      border-bottom: 1px solid #e4e7ed;

      .param-item {
        display: flex;
        justify-content: space-between;
        margin-bottom: 8px;
        font-size: 14px;

        &:last-child {
          margin-bottom: 0;
        }

        .label {
          color: #606266;
        }

        .value {
          color: #303133;
          font-weight: 500;
        }
      }
    }

    .price-stock {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin: 16px 0;

      .price {
        .label {
          font-size: 14px;
          color: #606266;
        }

        .value {
          font-size: 20px;
          color: #F56C6C;
          font-weight: bold;
        }
      }

      .stock {
        font-size: 14px;

        &.in-stock {
          color: #67C23A;
        }

        &.out-stock {
          color: #F56C6C;
        }
      }
    }

    .match-score {
      font-size: 14px;
      color: #606266;

      span {
        margin-right: 8px;
      }
    }
  }

  .select-icon {
    display: none;
    position: absolute;
    top: 50%;
    right: 20px;
    transform: translateY(-50%);
    width: 40px;
    height: 40px;
    border-radius: 50%;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    font-size: 24px;
    align-items: center;
    justify-content: center;
  }
}

/* 确认内容 */
.confirmation-content {
  .highlight {
    font-size: 18px;
    color: #667eea;
    font-weight: bold;
  }

  .price-highlight {
    font-size: 20px;
    color: #F56C6C;
    font-weight: bold;
  }
}

/* 搜索表单 */
.search-form {
  margin-bottom: 20px;

  /deep/ .el-form-item {
    margin-bottom: 0;
  }
}

/* 表格样式 */
.stock-normal {
  color: #67C23A;
  font-weight: bold;
}

.stock-out {
  color: #F56C6C;
  font-weight: bold;
}

.danger-text {
  color: #F56C6C;
}

.expand-content {
  padding: 20px;
  background: #f5f7fa;
}

/* 响应式 */
@media (max-width: 767px) {
  .gearbox-selection {
    padding: 10px;
  }

  .stats-row {
    /deep/ .el-col {
      margin-bottom: 12px;
    }
  }

  .selection-form {
    /deep/ .el-col {
      width: 100%;
    }
  }

  .step-actions {
    flex-direction: column;

    .el-button {
      width: 100%;
    }
  }

  .search-form {
    /deep/ .el-form-item {
      display: block;
      margin-bottom: 12px;

      .el-input,
      .el-select,
      .el-date-picker {
        width: 100%;
      }
    }
  }
}

@media (min-width: 768px) and (max-width: 1024px) {
  .stats-row {
    /deep/ .el-col {
      width: 50%;
      margin-bottom: 12px;
    }
  }
}
</style>
