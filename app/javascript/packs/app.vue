<template>
    <div id="app" class="container">
        <b-row>
            <b-col>
                <p><strong>{{ message }}</strong></p>
            </b-col>
        </b-row>
        <b-row no-gutters>
            <b-col cols="6">
                <schedule/>
            </b-col>
            <b-col cols="6">
                <task-view/>
            </b-col>
            <b-col>
                <obstacle-view/>
                <router-view></router-view>
            </b-col>
        </b-row>
    </div>
</template>

<script>
import Schedule from './components/Schedule.vue'
import TaskView from './components/TaskView.vue'
import ObstacleView from './components/ObstacleView.vue'

export default {
  data: function () {
    return {
      message: "Let's if-then-planning!"
    }
  },
  components: {
    Schedule,
    TaskView,
    ObstacleView
  }
}
</script>

<style lang="scss" scoped>
#TaskView {
    height: 500px;
    overflow: scroll;
    resize: both;
}
p strong {
  font-size: 2em;
  text-align: center;
}
</style>
