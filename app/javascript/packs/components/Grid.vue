<template>
  <div class="table">
      <md-table v-model="filteredData" md-sort="due" md-sort-order="asc">
          <md-table-toolbar>
              <h1 class="md-title">ToDos</h1>
          </md-table-toolbar>
          <tr class="md-table-head">
              <th clsss="md-table-head" v-for="key in columns"
                                        v-on:click="sortBy(key)"
                                        :class="{ active: sortKey == key }">
                  {{ key | capitalize }}
                  <span class="arrow" :class="sortOrders[key] > 0 ? 'asc' : 'dsc'"></span>
              </th>
          </tr>
          <tr class="md-table-cell" v-for="entry in filteredData">
              <td v-for="key in columns" >
                  <input type="checkbox" v-if="key == 'is_done' && entry[key] == true" checked="checked">
                  <input type="checkbox" v-else-if="key == 'is_done'">
                  <span v-else> {{ entry[key] }}</span>
              </td>
          </tr>
      </md-table>
  </div>
</template>

<script>
export default {
  name: 'Grid',
  props: {
    data: Array,
	columns: Array,
	filterKey: String
  },
  data () {
    let sortOrders = {}
	this.columns.forEach(function(key) {
	  sortOrders[key] = 1
	})
    return {
	  sortKey: '',
	  sortOrders: sortOrders,
      todoArray: this.data
    }
  },
  computed: {
    filteredData: function () {
  	  let sortKey = this.sortKey;
  	  let filterKey = this.filterKey && this.filterKey.toLowerCase();
  	  let order = this.sortOrders[sortKey] || 1;
  	  let data = this.data;
  	  if (filterKey) {
          // filter by task name
          data = data.filter(function (row) {
              return String(row['name']).toLowerCase().indexOf(filterKey) > -1
          })
      }
      if (sortKey) {
        data = data.slice().sort(function (a, b) {
          a = a[sortKey];
          b = b[sortKey];
          return (a === b ? 0 : a > b ? 1 : -1) * order
        })
      }
      return data
    }
  },
  filters: {
    capitalize: function (str) {
      return str.charAt(0).toUpperCase() + str.slice(1)
    }
  },
  methods: {
    sortBy: function (key) {
      this.sortKey = key
      this.sortOrders[key] = this.sortOrders[key] * -1
    }
  },
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
th {
    font-size: 1.2em;
    color: white;
    background: #448aff;
    height: 20px;
    padding: 0px 0px 0px 10px;
}

td {
    /*
    border-right: solid 1px;
    border-right-color: #C0C0C0;
     */
    border-bottom: solid 0.5px;
    border-bottom-color: #C0C0C0;
    padding: 0px 0px 0px 10px;
}
.arrow {
  display: inline-block;
  vertical-align: middle;
  width: 0;
  height: 0;
  margin-left: 5px;
  opacity: 0.66;
}

.arrow.asc {
  border-left: 4px solid transparent;
  border-right: 4px solid transparent;
  border-bottom: 4px solid #fff;
}

.arrow.dsc {
  border-left: 4px solid transparent;
  border-right: 4px solid transparent;
  border-top: 4px solid #fff;
}
</style>
