<template>
    <div id="schedule">
        <div class="hour scale" v-for="hour in hours">
            <div class="time-label">
                <span>{{ hour > 9 ? hour : "0" + hour }}{{ ":00" }}</span>
            </div>
            <div class="time-block"></div>
        </div>
        <md-button class="md-fab md-mini md-primary" @click="fetchEvents"><md-icon>refresh</md-icon></md-button>
        <md-field class="md-layout-item">
            <md-input v-model="eventSummary"></md-input>
            <md-input v-model="eventStart"></md-input>
            <md-input v-model="eventEnd"></md-input>
            <md-button type="submit" @click="createEvent" class="md-accent md-fab md-mini"><md-icon>add</md-icon></md-button>
        </md-field>
    </div>
</template>

<script>
import axios from 'axios'

export default {
    name: 'schedule',
    data: function () {
        return {
            hours: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23],
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
        todayEvent: function() {
            let today = new Date;
            let ymd = today.toISOString().substr(0,10);
            let data = this.eventList
            data = data.filter(function(obj) {
                return obj.start.date_time.indexOf(ymd) > -1;
            })
            return data;
        }
    },
}
</script>

<style scoped>
.hour {
    height: 40px;
    /*width: 40px;*/
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
