import 'babel-polyfill'
import Vue from 'vue/dist/vue.esm'
import Vuex from 'vuex'

Vue.use(Vuex)

const store = new Vuex.Store({
    state: {
        eventList: []
    },
    mutations: {
    },
})

export default store

