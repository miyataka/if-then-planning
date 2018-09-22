<template>
    <div id="TaskView">
        <b-row id="taskview-header">
            <b-col cols="6">
                TaskView
            </b-col>
            <b-col cols="2">
                <md-menu md-align-trigger>
                    <md-button md-menu-trigger class="md-icon-button md-small md-primary">
                        <md-icon>filter_list</md-icon>
                    </md-button>
                    <md-menu-content>
                        <md-menu-item>
                            <md-button @click="doFilter('complete')">
                                Complete-task
                            </md-button>
                        </md-menu-item>
                        <md-menu-item>
                            <md-button @click="doFilter('incomplete')">
                                Incomplete-task
                            </md-button>
                        </md-menu-item>
                        <md-menu-item>
                            <md-button @click="doFilter('')">
                                All
                            </md-button>
                        </md-menu-item>
                    </md-menu-content>
                </md-menu>
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
        <b-row :id="computedTaskId(task.id)" v-for="task in filteredTask" style="vertical-align: middle;">
            <b-col cols="1" style="align-items: center;" v-model="task.is_done">
                <md-icon class="text-primary" v-if="!task.is_done">check_box_outline_blank</md-icon>
                <md-icon class="text-primary" v-else>check_box</md-icon>
            </b-col>
            <b-col cols="7">
                <input class="taskname"
                       placeholder="task_name!"
                       style="overflow: hidden; resize: none; height: 1.5em; width: 100%; vertical-align: baseline;"
                       v-model="task.name"
                       @change="updateTask(task.id, task.name, task.is_done, task.due)" />
            </b-col>
            <b-col class="due-col" cols="3">
                <span class="cal_icon">
                    <md-icon class="text-primary">calendar_today</md-icon>
                </span>
                <input type="text"
                       class="due"
                       placeholder="due!!"
                       style="height: 1.5em; width: 100%;"
                       v-model="task.due"/>
            </b-col>
        </b-row>
        </div>
    </div>
</template>

<script>
import axios from 'axios'

export default {
    name: 'TaskView',
    data () {
        return {
            gridColumns: ['is_done', 'name', 'due'],
            taskList: [],
            addTaskViewVisible: false,
            addTaskName: '',
            addTaskDue: '',
            filterkey: '',
        }
    },
    methods: {
        fetchTasks: function() {
            axios.get('/api/v1/tasks')
                .then((response) => {
                    this.taskList = []
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
        updateTask: function(id, name, is_done, due) {
            let url = '/api/v1/tasks/' + id
            let task = this.taskList.filter(function(row) {
                           return id == row.id
                       });
            //console.log(task)
            axios.put(url, { task: { id: String(task[0].id),
                                     due: due,
                                     name: name,
                                     is_done: is_done }})
                .then((response) => {
                    if(response == "undefined") return
                    let newTaskList = this.taskList.filter(function(task) {
                                   return task.id !== task[0].id
                               })
                    newTaskList.unshift(response.data.task)
                    this.taskList = newTaskList
                }, (error) => {
                    console.log(error);
                });
        },
        toggleAddTaskView: function() {
            this.addTaskViewVisible = !this.addTaskViewVisible
        },
        toggleTaskStatus: function() {
            this.addTaskViewVisible = !this.addTaskViewVisible
        },
        doFilter: function(keyword) {
            this.filterkey = keyword;
        },
        computedTaskId: function(id) {
            return "task-" + id
        },
        syncTaskList: function() {

        },
    },
    mounted: function() {
        this.fetchTasks();
    },
    computed: {
        filteredTask: function() {
            let key = this.filterkey
            let list = this.taskList
            if(key == "complete") {
                list = list.filter(function (task) { return task.is_done; })
            } else if (key == "incomplete") {
                list = list.filter(function (task) { return !task.is_done; })
            } else {
                // no filter
            }
            return list;
        }
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
