<template>
  <div class="row">
    <div class="col">
      <h3>Register</h3>

      <form
        @submit.prevent="submit"
        :class="{ error: responseStatus, loading }"
      >
        <div class="form-group">
          <error-summary
            except="displayName,email,password,confirmPassword"
            :response-status="responseStatus"
          />
        </div>
        <div class="form-group">
          <v-input
            id="displayName"
            v-model="displayName"
            :response-status="responseStatus"
            placeholder="Display Name"
            label="Name"
            help="Your first and last name"
          />
        </div>
        <div class="form-group">
          <v-input
            id="email"
            v-model="email"
            :response-status="responseStatus"
            placeholder="Email"
            label="Email"
          />
        </div>
        <div class="form-group">
          <v-input
            type="password"
            id="password"
            v-model="password"
            :response-status="responseStatus"
            placeholder="Password"
            label="Password"
          />
        </div>
        <div class="form-group">
          <v-input
            type="password"
            id="confirmPassword"
            v-model="confirmPassword"
            :response-status="responseStatus"
            placeholder="Confirm"
            label="Confirm Password"
          />
        </div>
        <div class="form-group">
          <v-checkbox
            id="autoLogin"
            v-model="autoLogin"
            :response-status="responseStatus"
          >
            Auto Login
          </v-checkbox>
        </div>
        <div class="form-group">
          <v-button type="submit" lg primary>Register</v-button>
          <link-button href="/signin" nav-item-class="btn">Sign In</link-button>
        </div>
      </form>
    </div>
  </div>
</template>

<script>
import { mapGetters } from "vuex"
import { Register } from "../shared/dtos"
import { Routes } from "../shared"
import { checkAuth, register } from "../shared/gateway"

export default {
  data: () => ({
    displayName: "",
    email: "",
    userName: "",
    password: "",
    confirmPassword: "",
    autoLogin: true,
    loading: false,
    responseStatus: null
  }),

  computed: {
    ...mapGetters(["nav", "userAttributes", "userSession"])
  },

  methods: {
    async submit() {
      try {
        this.loading = true
        this.responseStatus = null

        await register(
          new Register({
            displayName: this.displayName,
            email: this.email,
            password: this.password,
            confirmPassword: this.confirmPassword,
            autoLogin: this.autoLogin
          })
        )

        this.$store.dispatch("signin", await checkAuth())

        this.$router.push(Routes.Home)
      } catch (e) {
        this.responseStatus = e.responseStatus || e
      } finally {
        this.loading = false
      }
    }
  }
}
</script>
