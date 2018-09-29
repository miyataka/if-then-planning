<template>
    <section id="schedule">
        <b-row id="schedule-header" class="sticky-header">
            <b-col cols="8">{{ today_ymd }}</b-col>
            <b-col cols="4">
                <md-button class="md-fab md-mini md-primary" @click="fetchEvents">
                    <md-icon>refresh</md-icon>
                </md-button>
                <md-button @click="toggleAddEventView" class="md-accent md-fab md-mini">
                    <md-icon>add</md-icon>
                </md-button>
                <div class="addEventView" v-show="addEventViewVisible">
                    <form>
                        <input type="text"
                               v-model="eventSummary"
                               placeholder="event summary..." />
                        <datepicker type="text"
                                    v-model="eventStart"
                                    placeholder="when event starts..."
                                    format="yyyy-MM-dd"
                                    @closed="createEvent"></datepicker>
                        <md-button class="md-mini md-icon-button md-raised md-primary"
                            @click="createEvent">
                            <md-icon>edit</md-icon>
                        </md-button>
                    </form>
                </div>
            </b-col>
        </b-row>
        <div id="schedule-body">
            <b-row class="hour scale" v-for="hour in 24" :key="hour">
                <div class="time-label">
                    <span>{{ (hour - 1) > 9 ? (hour - 1) : "0" + (hour - 1)}}{{ ":00" }}</span>
                </div>
                <div class="time-block">
                    <div class="event md-accent"
                         v-if="todayEventsList.get(String(hour - 1))"
                         v-bind:style="todayEventsList.get(String(hour - 1))"
                         @click="toggleEventDetailView">
                        <span class="event_summary" v-if="todayEventsList.get(String(hour - 1) + '_task')"
                              v-bind:style="todayEventsList.get(String(hour - 1) + '_task_style')">
                            {{ todayEventsList.get(String(hour - 1) + '_task') }}
                        </span>
                        <div class="event_detail"
                             :class="{ open: eventDetailViewVisible }"
                             v-if="eventDetailViewVisible">
                            <div class="event_description">
                                <span>some description</span>
                            </div>
                            <div class="eventActionBar">
                                <md-button class="md-small md-icon-button">
                                    <md-icon>delete</md-icon>
                                </md-button>
                            </div>
                        </div>
                    </div>
                </div>
            </b-row>
        </div>
    </section>
</template>

<script>
import axios from 'axios'
import Datepicker from 'vuejs-datepicker'

export default {
    name: 'schedule',
    data () {
        return {
            addEventViewVisible: false,
            eventList: [],
            eventSummary: '',
            eventStart: '',
            eventEnd: '',
            eventDetailViewVisible: false,
        }
    },
    components: {
        Datepicker
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
            if(this.eventSummary) return;
            axios.post('/api/v1/event', { event: { summary: this.eventSummary, start: this.eventStart, end: this.eventEnd }})
                .then((response) => {
                        console.log(response.data);
                }, (error) => {
                        console.log(error);
                });
        },
        deleteEvent: function() {
            let url = '/api/v1/event/' + id
            let calendar_id = 'primary' // fixed value, now.
            axios.delete(url, {
                params: {
                    event_id: event_id,
                    calendar_id: calendar_id,
                }
            })
                .then(() => {
                    // remove event local eventList
                }, (error) => {
                    console.log(error);
                });
        },
        toggleAddEventView: function() {
            this.addEventViewVisible = !this.addEventViewVisible
        },
        toggleEventDetailView: function() {
            this.eventDetailViewVisible = !this.eventDetailViewVisible
        },
    },
    mounted: function() {
        this.fetchEvents();
    },
    computed: {
        today_ymd: function() {
            let now = new Date();
            let y = now.getFullYear();
            let m = now.getMonth() + 1;
            let d = now.getDate();
            if (m < 10) {
                m = '0' + m;
            }
            return y + '-' + m + '-' + d;
        },
        todayEvents: function() {
            let today = new Date;
            let ymd = today.toISOString().substr(0,10);
            let data = this.eventList
            data = data.filter(function(obj) {
                if("date_time" in obj.start){
                    return obj.start.date_time.indexOf(ymd) > -1;
                }else if("date" in obj.start){
                    return obj.start.date.indexOf(ymd) > -1;
                }
                return false;
            })
            data = data.slice().sort(function(a, b) {
                return (a.start.date_time == b.start.date_time ? 0 : a.start.date_time > b.start.date_time ? 1 : -1)
            })
            return data;
        },
        todayEventsList: function () {
            let te = this.todayEvents;
            let ymd = this.today_ymd;
            let te_list2 = new Map();
            let te_list3 = new Array();
            let _top
            let style_string = 'width: 90%; ' +
                               'z-index: 1; ' +
                               'background-color: red; ' +
                               'height: 90%; ' +
                               '';
            let AllDayEvent_style_string = 'width: 90%; ' +
                                           'z-index: 1; ' +
                                           'background-color: red; ' +
                                           'height: 90%; ' +
                                           '';
            let span_style_string = 'color: white; ' +
                                    'background: inherit; ' +
                                    'left: 3px; ' +
                                    'top: auto;' ;

            te.forEach(function(obj) {
                if("date_time" in obj.start) {
                    te_list2.set(obj.start.date_time.substring(11,13),
                                 style_string + "top: " + (obj.start.date_time.substring(11,13) * 40) + 'px;');
                    te_list2.set(obj.start.date_time.substring(11,13) + "_task",
                                 obj.summary);
                    te_list2.set(obj.start.date_time.substring(11,13) + "_task_style",
                                 span_style_string);
                } else if("date" in obj.start){
                    te_list3.push(obj.summary)
                    te_list2.set(ymd + "_task",
                                 te_list3);
                    if(te_list3.length > 0){
                        _top = te_list3.length * 18 + 'px; '
                    }
                    te_list2.set(ymd + "_task_style",
                                 AllDayEvent_style_string + _top);
                } else {
                    //do nothing
                    console.log("do nothing")
                }
            })

            return te_list2;
        },
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
div.addEventView {
    display: inline-flex;
    width: auto;
    border: #e3e3e3 1px solid;
    position: relative;
    z-index: 3;
    background: white;
    color: black;
}

.time-block .event_summary {
    display: inline-block;
}
.time-block .eventActionBar {
    display: inline-block;
    text-align: right;
}
.time-block .event_detail.open {
    display: block;
    position: relative;
        /*
    top: -100px;
    left: 100px;
        */
    z-index: 5;
    height: auto;
    width: 100%;
    background: white;
    color: red;
    border: red 1px solid;
}

.event_description > span {
    display: block;
    position: relative;
    top: auto;
    background: #fff;
}
.event_description > div {
    display: block;
}
</style>
