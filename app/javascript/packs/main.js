import Vue from 'vue/dist/vue.esm'
import App from './app.vue'
import router from './router/router'

import store from './store/store'

import VueMaterial from 'vue-material'
import 'vue-material/dist/vue-material.min.css'     // doesn't work
import 'vue-material/dist/theme/default-dark.css'   // doesn't work
Vue.use(VueMaterial)

document.addEventListener('DOMContentLoaded', () => {
    const el = document.body.appendChild(document.createElement('App'))
    const app = new Vue({
        el,
        router,
        store,
        components: { App }
    })
})

