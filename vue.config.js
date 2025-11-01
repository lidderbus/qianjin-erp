module.exports = {
  publicPath: process.env.NODE_ENV === 'production' ? '/qianjin-erp/' : '/',
  outputDir: 'dist',
  assetsDir: 'static',
  productionSourceMap: false,
  devServer: {
    port: 8080,
    open: true,
    overlay: {
      warnings: false,
      errors: true
    }
  },
  chainWebpack: config => {
    config.plugin('html').tap(args => {
      args[0].title = '前进ERP管理系统'
      return args
    })
  }
}
