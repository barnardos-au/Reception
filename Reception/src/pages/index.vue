<template>
  <div>
    <h3>Visitor Check In</h3>
    <div>
      <div v-if="userSession">
        <p class="pt-3">Hi {{ userSession.displayName }}!</p>

        <form
          ref="form"
          @submit.prevent="saveVisit"
          :class="{ error: responseStatus, loading }"
        >
          <div class="form-group">
            <v-input
              id="name"
              v-model="name"
              placeholder="Who are you visiting today?"
              required
            />
          </div>

          <div class="form-group">
            <v-input
              id="carRegistration"
              v-model="carRegistration"
              placeholder="Car Registration"
            />
          </div>

          <div class="form-group">
            <v-input
              id="contactNumber"
              v-model="contactNumber"
              placeholder="Contact Number"
              required
            />
          </div>

          <div class="form-group">
            <v-input
              id="purpose"
              v-model="purpose"
              placeholder="Reason for visit?"
              required
            />
          </div>

          <div class="form-group">
            <div class="form-check">
              <input
                class="form-check-input"
                type="radio"
                name="employeeType"
                id="radio_Employee"
                value="Employee"
                v-model="visitorType"
                required
              />
              <label class="form-check-label" for="radio_Employee">
                Employee
              </label>
            </div>
            <div class="form-check">
              <input
                class="form-check-input"
                type="radio"
                name="employeeType"
                id="radio_Contractor"
                value="Contractor"
                v-model="visitorType"
                required
              />
              <label
                class="form-check-label label label-default"
                for="radio_Contractor"
              >
                Contractor
              </label>
            </div>
          </div>

          <div class="form-group">
            <button type="submit" class="btn btn-block btn-primary">
              Save
            </button>
          </div>
        </form>
      </div>
      <div v-else>
        <p class="pt-3">Please sign in or register to record your visit.</p>
        <div class="form-group">
          <link-button href="/signin" nav-item-class="btn btn-lg btn-primary">
            Sign In</link-button
          >
          <link-button href="/signup" lg outline-secondary class="ml-2"
            >Register</link-button
          >
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters, mapActions } from "vuex"
import { Routes } from "../shared"
import { CreateVisit } from "../shared/dtos"
import moment from "moment"

export default {
  data: () => ({
    loading: false,
    responseStatus: null,
    value: "",
    name: "",
    visitorType: null,
    carRegistration: null,
    contactNumber: null,
    purpose: null,
    visitTime: ""
  }),

  computed: {
    ...mapGetters(["userSession", "user"]),
    displayCurrentDateTime: function () {
      return moment(this.visitTime).format("DD MMM YYYY hh:mm:ss")
    }
  },

  created() {
    this.init()
  },

  mounted() {},

  methods: {
    ...mapActions(["createVisit", "getUser"]),
    async init() {
      await this.getUser()
      this.setUserDetails()
      this.setDateTime()
    },
    setDateTime: function () {
      setInterval(() => {
        this.visitTime = moment().toDate()
      }, 500)
    },
    setUserDetails: function () {
      if (this.user) {
        if (this.user.phoneNumber) {
          this.contactNumber = this.user.phoneNumber
        }
        if (this.user.carRegistration) {
          this.carRegistration = this.user.carRegistration
        }
      }
    },
    saveVisit: async function () {
      try {
        this.loading = true
        this.responseStatus = null

        let request = new CreateVisit({
          hostName: this.name,
          visitorType: this.visitorType,
          dateTime: moment(this.visitTime),
          carRegistration: this.carRegistration,
          contactNumber: this.contactNumber
        })
        await this.createVisit(request)

        this.$router.push(this.$route.query.redirect || Routes.Visit)
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
</style>
