<template>
    <div id="TaskView">
        <b-row id="taskview-header">
            <b-col cols="8" style="height: 40px;">
                TaskView
            </b-col>
            <b-col cols="4">
                <md-button class="md-fab md-mini md-primary" @click="fetchTasks">
                    <md-icon>refresh</md-icon>
                </md-button>
                <md-button type="submit" @click="toggleAddTaskView" class="md-accent md-fab md-mini">
                    <md-icon>add</md-icon>
                </md-button>
                <div class="addTaskView" v-show="addTaskViewVisible">
                    <form>
                        <input type="text" v-model="addTaskName" placeholder="taskname..." />
                        <input type="text" v-model="addTaskDue" placeholder="taskdue..." />
                        <md-button class="md-mini md-icon-button md-raised md-primary"
                            @click="createTask">
                            <md-icon>edit</md-icon>
                        </md-button>
                    </form>
                </div>
            </b-col>
        </b-row>
        <div id="taskview-body">
        <b-row v-for="task in taskList" style="vertical-align: middle;">
            <b-col cols="1" style="align-items: center;">
                <md-icon class="text-primary" v-if="!task.is_done">check_box_outline_blank</md-icon>
                <md-icon class="text-primary" v-else>check_box</md-icon>
            </b-col>
            <b-col cols="7">
                <textarea class="taskname"
                          placeholder="task_name!"
                          style="overflow: hidden; resize: none; height: 1.5em; width: 100%; vertical-align: baseline;">
                    {{task.name}}
                </textarea>
            </b-col>
            <b-col class="due-col" cols="3">
                <span class="cal_icon">
                    <md-icon class="text-primary">calendar_today</md-icon>
                </span>
                <input type="text"
                       class="due"
                       placeholder="due!!"
                       style="height: 1.5em; width: 100%;"
                       :value="task.due"/>
            </b-col>
        </b-row>
        </div>
    </div>
</template>

<script>
import axios from 'axios'

export default {
    name: 'TaskView',
    data: function () {
        return {
            showSearchBox: false,
            showCreateBox: false,
            searchQuery: '',
            gridColumns: ['is_done', 'name', 'due'],
            taskList: [],
            addTaskViewVisible: false,
            addTaskName: '',
            addTaskDue: '',
        }
    },
    methods: {
        fetchTasks: function() {
            axios.get('/api/v1/tasks')
                .then((response) => {
                    for(let i = 0; i < response.data.length; i++) {
                        this.taskList.push(response.data[i]);
                    }
                }, (error) => {
                    console.log(error);
                });
        },
        createTask: function() {
            if (!this.addTaskName || !this.addTaskDue) return;
            axios.post('/api/v1/tasks', { task: { name: this.addTaskName, due: this.addTaskDue }})
                .then((response) => {
                    this.taskList.unshift(response.data.task);
                    this.addTaskName = '';
                    this.addTaskDue = '';
                }, (error) => {
                    console.log(error)
                });
        },
        toggleAddTaskView: function() {
            this.addTaskViewVisible = !this.addTaskViewVisible
        }
    },
    mounted: function() {
        this.fetchTasks();
    },
}
</script>

<style scoped>
/* TODO extract style attribute from template */
div#taskview-body {
    height: 500px;
    overflow: scroll;
    resize: both;
    padding-top: 10px;
}
div#taskview-header {
    zindex: 1;
    height: 40px;
}
div#taskview-header .md-fab {
    display: flex-end;
}
.due-col {
    display: inline-flex;
}

div.addTaskView {
    display: inline-flex;
    width: auto;
    border: #e3e3e3 1px solid;
    position: relative;
    z-index: 3;
    background: white;
    color: black;
}
</style>
