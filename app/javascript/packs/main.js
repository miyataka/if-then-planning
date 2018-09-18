import Vue from 'vue/dist/vue.esm'
import App from './app.vue'
import router from './router/router'

import store from './store/store'

import VueMaterial from 'vue-material'
import 'vue-material/dist/vue-material.min.css'     // doesn't work
import 'vue-material/dist/theme/default.css'   // doesn't work
Vue.use(VueMaterial)

import BootstrapVue from 'bootstrap-vue'
import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue/dist/bootstrap-vue.css'
Vue.use(BootstrapVue)

document.addEventListener('DOMContentLoaded', () => {
    const el = document.body.appendChild(document.createElement('App'))
    const app = new Vue({
        el,
        router,
        store,
        components: { App }
    })
})

