<template>
    <div id="TaskView">
        <b-row>
            <b-col style="height: 40px;">
                TaskView
            </b-col>
        </b-row>
        <b-row v-for="task in gridData" style="vertical-align: middle;">
            <b-col cols="1" style="align-items: center;">
                <md-icon class="text-primary" v-if="!task.is_done">check_box_outline_blank</md-icon>
                <md-icon class="text-primary" v-else>check_box</md-icon>
            </b-col>
            <b-col cols="7">
                <textarea class="taskname" placeholder="task_name!" style="overflow: hidden; resize: none; height: 1.5em; width: 100%; vertical-align: baseline;">
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
</template>

<script>
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
                { name: 'Sample Task1', is_done: false,     due: "2018/08/19"},
                { name: 'Sample Task2', is_done: true,     due: "2018/08/19"},
            ]
        }
    },
}
</script>

<style scoped>
.due-col {
    display: inline-flex;
}
.cal_icon {
    display: inline-block;
}
</style>
