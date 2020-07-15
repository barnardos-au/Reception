<template>
  <div>
    <div>
      <div v-if="userSession">
        <p class="pt-3">Hi {{ userSession.displayName }}!</p>
      </div>

      <div v-if="visit">
        <div class="form-group">
          <div>Check Out Time: {{ displayCurrentDateTime }}</div>
          <button
            type="submit"
            @click="saveVisit"
            class="btn btn-block btn-primary"
          >
            End Visit
          </button>
        </div>
      </div>
      <div v-else>
        <p>You have no active visits</p>
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters, mapActions } from "vuex"
import { EndVisit } from "../shared/dtos"
import moment from "moment"

export default {
  data: () => ({
    visitTime: moment().toDate()
  }),

  computed: {
    ...mapGetters(["userSession", "visit"]),
    displayCurrentDateTime: function () {
      return moment(this.visitTime).format("DD MMM YYYY hh:mm:ss")
    }
  },

  created() {
    this.setDateTime()
  },

  mounted() {},

  methods: {
    ...mapGetters(["visit"]),
    ...mapActions(["endVisit"]),
    setDateTime: function () {
      setInterval(() => {
        this.visitTime = moment().toDate()
      }, 500)
    },
    saveVisit: async function () {
      try {
        this.loading = true
        this.responseStatus = null

        let visitId = this.visit.id

        let request = new EndVisit({
          id: visitId,
          visitEndedDateTime: moment(this.visitTime)
        })
        await this.endVisit(request)

        //this.$router.push(this.$route.query.redirect || Routes.Home);
      } catch (e) {
        this.responseStatus = e.responseStatus || e
      } finally {
        this.loading = false
      }
    }
  }
}
</script>

<style>
.splash {
  min-height: 60vh;
  display: flex;
  justify-content: center;
  align-items: center;
  text-align: center;
}

.title {
  font-family: "Quicksand", "Source Sans Pro", -apple-system, BlinkMacSystemFont,
    "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
  display: block;
  font-weight: 300;
  font-size: 100px;
  color: #35495e;
  letter-spacing: 1px;
}

.subtitle {
  font-weight: 300;
  font-size: 42px;
  color: #526488;
  word-spacing: 5px;
  padding-bottom: 15px;
}

.result {
  padding-top: 15px;
  height: 30px;
  line-height: 30px;
  font-size: 24px;
}
</style>
