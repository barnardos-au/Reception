<template>
  <div v-if="userSession" id="admin" class="text-center">
    <p class="my-2">
      {{ userSession.displayName }}
    </p>
    <p>
      {{ userSession.userName }}
    </p>
    <p v-if="userSession && userSession.roles" class="roles">
      <mark v-for="x in userSession.roles" :key="x">{{ x }}</mark>
    </p>

    <div v-if="visitors">
      <b-form-input
        v-model="filter"
        placeholder="Type to Search"
      ></b-form-input>

      <b-table hover :fields="fields" :items="visitors" :filter="filter">
        <template v-slot:cell(dateTime)="data">
          {{ displayDate(data) }}
        </template>
        <template v-slot:cell(endDateTime)="data">
          {{ displayDate(data) }}
        </template>
      </b-table>
    </div>
  </div>
</template>

<script>
import { mapGetters, mapActions } from "vuex"
import { requiresRole } from "../../shared"
import moment from "moment"

export default {
  layout: "admin",
  data: () => ({
    fields: [
      { key: "hostName", sortable: true },
      { key: "visitorName", sortable: true },
      { key: "visitorType", sortable: true },
      { key: "dateTime", sortable: true },
      { key: "contactNumber", sortable: true },
      { key: "carRegistration", sortable: true },
      { key: "endDateTime", sortable: true }
    ],
    filter: null
  }),

  computed: {
    ...mapGetters(["userSession", "visitors"])
  },

  mounted() {
    this.requiresRole("Admin")
  },

  created() {
    this.init()
  },

  methods: {
    ...mapActions(["getVisitors"]),
    async init() {
      await this.getVisitors()
    },
    displayDate: (date) => {
      if (date && date.value) {
        return moment(date.value).format("DD MMM YYYY hh:mm:ss a")
      }
    },
    requiresRole
  }
}
</script>
