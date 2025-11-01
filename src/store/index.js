import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    userInfo: null,
    stats: {
      quotations: 0,
      orders: 0,
      customers: 0,
      attendance: 0
    },
    recentModules: []
  },
  mutations: {
    SET_USER_INFO(state, userInfo) {
      state.userInfo = userInfo
    },
    SET_STATS(state, stats) {
      state.stats = stats
    },
    SET_RECENT_MODULES(state, modules) {
      state.recentModules = modules
    },
    ADD_RECENT_MODULE(state, module) {
      const index = state.recentModules.findIndex(m => m.url === module.url)
      if (index > -1) {
        state.recentModules.splice(index, 1)
      }
      state.recentModules.unshift(module)
      if (state.recentModules.length > 8) {
        state.recentModules = state.recentModules.slice(0, 8)
      }
    }
  },
  actions: {
    login({ commit }, userInfo) {
      commit('SET_USER_INFO', userInfo)
      localStorage.setItem('userInfo', JSON.stringify(userInfo))
    },
    logout({ commit }) {
      commit('SET_USER_INFO', null)
      localStorage.removeItem('userInfo')
      localStorage.removeItem('cachedStats')
      localStorage.removeItem('recentModules')
    },
    updateStats({ commit }, stats) {
      commit('SET_STATS', stats)
      localStorage.setItem('cachedStats', JSON.stringify(stats))
    }
  },
  getters: {
    isLoggedIn: state => !!state.userInfo,
    userName: state => state.userInfo?.realName || '',
    userDepartment: state => state.userInfo?.department || '',
    userPosition: state => state.userInfo?.position || ''
  }
})
