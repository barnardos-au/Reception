<template>
  <div>
    <link rel="stylesheet" href="/css/buttons.css" />
    <link rel="stylesheet" href="/css/svg-auth.css" />
    <link rel="stylesheet" href="/css/svg-icons.css" />
    <nav class="navbar navbar-expand-sm navbar-dark justify-content-center">
      <div class="container">
        <nuxt-link to="/">
          <div class="navbar-brand">
            <img
              src="~/assets/logo.png"
              alt="logo"
              class="img-thumbnail mr-1"
            />
          </div>
        </nuxt-link>

        <navbar :items="nav.results" :attributes="userAttributes" />
      </div>
    </nav>

    <div id="content" class="container">
      <nuxt />
    </div>

    <div id="footer" style="text-align: center;">
      <div></div>
    </div>
  </div>
</template>

<script>
import { mapGetters } from "vuex"

export default {
  computed: {
    ...mapGetters(["nav", "userAttributes"])
  }
}
</script>
