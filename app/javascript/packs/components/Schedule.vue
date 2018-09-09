<template>
    <section id="schedule">
        <b-row id="schedule-header" class="sticky-header">
            <b-col cols="9">{{ today_ymd }}</b-col>
            <b-col cols="3">
                <md-button class="md-fab md-mini md-primary" @click="fetchEvents">
                    <md-icon>refresh</md-icon>
                </md-button>
                <md-button type="submit" @click="createEvent" class="md-accent md-fab md-mini">
                    <md-icon>add</md-icon>
                </md-button>
            </b-col>
        </b-row>
        <div id="schedule-body">
            <b-row class="hour scale" v-for="hour in 24">
                <div class="time-label">
                    <span>{{ (hour - 1) > 9 ? (hour - 1) : "0" + (hour - 1)}}{{ ":00" }}</span>
                </div>
                <div class="time-block">
                    <div class="event md-accent"
                         v-if="todayEventsList.get(String(hour - 1))"
                         v-bind:style="todayEventsList.get(String(hour - 1))">
                    </div>
                </div>
            </b-row>
        </div>
    </section>
</template>

<script>
import axios from 'axios'

export default {
    name: 'schedule',
    data: function () {
        return {
            eventList: [],
            eventSummary: '',
            eventStart: '',
            eventEnd: '',
        }
    },
    methods: {
        fetchEvents: function() {
            axios.get('/api/v1/event')
                .then((response) => {
                    for(let i = 0; i < response.data.events.length; i++) {
                        this.eventList.push(response.data.events[i]);
                    }
                }, (error) => {
                    console.log(error);
                });
        },
        createEvent: function() {
            axios.post('/api/v1/event', { event: { summary: this.eventSummary, start: this.eventStart, end: this.eventEnd }})
                .then((response) => {
                        console.log(response.data);
                }, (error) => {
                        console.log(error);
                });
        }
    },
    mounted: function() {
        this.fetchEvents();
    },
    computed: {
        todayEvents: function() {
            let today = new Date;
            let ymd = today.toISOString().substr(0,10);
            let data = this.eventList
            data = data.filter(function(obj) {
                return obj.start.date_time.indexOf(ymd) > -1;
            })
            data = data.slice().sort(function(a, b) {
                return (a.start.date_time == b.start.date_time ? 0 : a.start.date_time > b.start.date_time ? 1 : -1)
            })
            return data;
        },
        todayEventsList: function () {
            let te = this.todayEvents;
            let te_list = new Array(24);
            let te_list2 = new Map();
            let style_string = 'width: 90%; ' +
                               'z-index: 1; ' +
                               'background-color: red; ' +
                               'height: 90%;' +
                               '';

            te_list = te.slice().sort(function(a, b) {
                return (a.start.date_time == b.start.date_time ? 0 : a.start.date_time > b.start.date_time ? 1 : -1)
            })

            te_list.forEach(function(obj) {
                te_list2.set(obj.start.date_time.substring(11,13),
                             style_string + "top: " + (obj.start.date_time.substring(11,13) * 40) + 'px;');
            })

            return te_list2;
        },
        today_ymd: function() {
            let now = new Date();
            let y = now.getFullYear();
            let m = now.getMonth();
            let d = now.getDate();
            if (m < 10) {
                m = '0' + m;
            }
            return y + '-' + m + '-' + d
        }
    },
}
</script>

<style scoped>
div#schedule-body {
    height: 500px;
    overflow: scroll;
    resize: both;
    padding-top: 10px;
}
div#schedule-header {
    zindex: 1;
    height: 40px;
}
div#schedule-header .md-fab {
    /*
    display: inline-block;
        */
}
.hour.scale {
    position: relative;
    height: 40px;
    border-right: 1px solid #e0e0e0;
    margin: 0px 0px 0px 0px;
}

.hour span {
    background: #fafafa;
    position: relative;
    top: -10px;
}

.time-label {
    display: inline-block;
    height: 100%;
    width: 10%;
}

.time-block {
    display: inline-block;
    height: 100%;
    width: 90%;
    float: right;
    color: red;
    border: 0.5px solid #e0e0e0;
    border-bottom: 0px;
}
</style>
