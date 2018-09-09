const { environment } = require('@rails/webpacker')
const vue =  require('./loaders/vue')
const css =  require('./loaders/css')
const image =  require('./loaders/image')

environment.loaders.append('vue', vue)
environment.loaders.append('css', css)
environment.loaders.append('image', image)
module.exports = environment
