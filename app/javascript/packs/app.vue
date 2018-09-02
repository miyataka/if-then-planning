<template>
    <div id="app">
        <p><strong>{{ message }}</strong></p>
      <div id="" class="md-layout">
          <schedule class="md-layout-item"/>
          <task-view class="md-layout-item"/>
          <obstacle-view class="md-layout-item"/>
      </div>
    <router-view></router-view>
  </div>
</template>

<script>
import schedule from './components/Schedule.vue'
import TaskView from './components/TaskView.vue'
import ObstacleView from './components/ObstacleView.vue'

export default {
  data: function () {
    return {
      message: "Let's if-then-planning!"
    }
  },
  components: {
    schedule,
    TaskView,
    ObstacleView
  }
}
</script>

<style lang="scss" scoped>
@import "~vue-material/dist/theme/engine"; // Import the theme engine

@include md-register-theme("default", (
  primary: md-get-palette-color(deeporange, A200), // The primary color of your application
  accent: md-get-palette-color(yellow, A200) // The accent or secondary color
));
@import "~vue-material/dist/theme/all"; // Apply the theme

#schedule {
    height: 300px;
    overflow: scroll;
    resize: both;
}

#TaskView {
    height: 300px;
    overflow: scroll;
    resize: both;
}
p {
  font-size: 2em;
  text-align: center;
}
</style>
