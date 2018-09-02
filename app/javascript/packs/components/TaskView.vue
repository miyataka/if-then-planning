<template>
    <div id="TaskView">
        <md-field class="md-layout-item" v-if="showSearchBox">
            <label><md-icon>search</md-icon>search by taskname ...</label>
            <md-input name="query" v-model="searchQuery"></md-input>
            <md-button class="md-primary md-fab md-mini"><md-icon>search</md-icon></md-button>
        </md-field>
        <md-field class="md-layout-item" v-if="showCreateBox">
            <label><md-icon>edit</md-icon>Create Task ...</label>
            <md-input v-model="newTask" @keyup.ctrl.enter="createTask"></md-input>
            <md-button type="submit" @click="createTask" class="md-accent md-fab md-mini"><md-icon>add</md-icon></md-button>
        </md-field>
        <grid
            :data="gridData"
            :columns="gridColumns"
            :filter-key="searchQuery">
        </grid>
    </div>
</template>

<script>
import Grid from './Grid';

export default {
    name: 'TaskView',
    data: function () {
        return {
            showSearchBox: false,
            showCreateBox: false,
            searchQuery: '',
            newTask: '',
            gridColumns: ['is_done', 'name', 'due'],
            gridData: [
                { name: 'Sample Task1', is_done: true,     due: "2018/08/19"},
            ]
        }
    },
    components: {
        Grid
    }
}
</script>

<style scoped>
</style>
