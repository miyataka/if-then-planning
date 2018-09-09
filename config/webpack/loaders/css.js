const { dev_server: devServer } = require('@rails/webpacker').config

const isProduction = process.env.NODE_ENV === 'production'
const inDevServer = process.argv.find(v => v.includes('webpack-dev-server'))

module.exports = {
  test: /\.css$/,
  use: [
      'style-loader',
      'css-loader',
  ]
}
