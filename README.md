Playing with Phoenix and Nuxt
=============================

Yeah, I'm doing it again!

Links while dev
---------------

* https://www.shadcn-vue.com
* https://v4.shadcn-vue.com
* https://nuxt.com/docs/api/nuxt-config
* https://nuxt.com/docs/guide/directory-structure/composables
* https://nitro.build/config
* https://lucide.dev/icons/
* https://tailwindcss.com/docs


Install
-------

```
mix phx.new app
```

Install the nuxt client, in the project root

```
npm create nuxt client
```

I chose npm. Confirmed the client runs with npm run dev

Instead of having the phoenix web server dishing out the nuxt app during dev (like i did when playing with phx_vue)
i've just set up a watcher in dev.exs and having the nuxt server handle all that. HMR is working in the client, all good.
When it comes to prod, i'll just need to figure out how to host this all. Something like this should work:

```
yourdomain.com {
  root * /path/to/client/.output/public
  file_server

  handle_path /api/* {
    reverse_proxy localhost:4000
  }

  # probably won't need this as will probably hit socket on `/api/socket`?
  handle_path /socket/* {
    reverse_proxy localhost:4000
  }
}
```

Socket
------

Started to play with the socket comms

```
mix phx.gen.socket User
mix phx.gen.channel Room

```

At this point, we can send messages from the client and collect the reply. We can also send messages from the
server using something like:

```
Web.Endpoint.broadcast("room:lobby", "poke", %{"msg" => "Hello this is a broadcast"})
```

You can restart the server and the client reconnects automatically, as advertised.

Docker
------

Building with a Docker container. See the Dockerfile, .dockerignore and build scripts for more info


Running the nuxt client in dev and test
---------------------------------------

Using Wallaby for end to end testing. I had a bit of trouble setting up the starting and closing of the nuxt client. I already had the problem in dev but hadn't really noticed. I haven't been able to programatically close down the client at the end of the test suite, or when killing the iex session.

I've landed on a solution for the test environment:

* Added a nuxt_helper that generates the nuxt client and calling it in test_helper to run at the start of the test suite
* Added a Plug.Static to the endpoint (test env only) to statically dish out the generated nuxt client

Happy with this as don't need the client to run in nuxt dev mode during tests.

For dev, I tried adding `npm run dev` as a watcher, but the process would hang around after killing iex, and nuxt would assign another port on the next run. I'm currently running the nuxt client in a separate terminal. 

I just need to make sure all the ports line up for both environments. I'm currently (hopefully) setting everything up in nuxt.config.ts and setting a TARGET env var on each call to nuxt generate or nuxt dev.

UPDATE: the nuxt dev client now runs automatically on starting the Phoenix server. It uses a wrapper (run_wrapper) to handle cleaning up zombie processes - see https://hexdocs.pm/elixir/Port.html#module-zombie-operating-system-processes for more info. The same strategy doesn't work so well in test unfortunately, there is always a process hanging around, so keep the existing strategy for test, ie generate a client and let Phoenix serve it, though i have kept a wip on implementing the wrapper and dev client in nuxt_helper.ex.


Installing shadcn
-----------------

As per https://www.shadcn-vue.com/docs/installation/nuxt.html

A few moving parts:

* Shadcn-vue: https://www.shadcn-vue.com/docs/introduction
* Shadcn-vue nuxt module: https://nuxt.com/modules/shadcn
* Tailwind wasn't installed using the nuxt module, just the npm package. tailwind.config.js wasn't created automatically, so did `npx tailwindcss-cli init` later, though could have just created it yourself, but this command gave it a bit of a baseline.
* Lucide vue next: https://lucide.dev/guide/packages/lucide-vue-next

Files and dirs created during installation:

* components/ui - where the components go
* assets/css/tailwind/css - got populated when installing shadcn
* lib/utils.ts - tw merge stuff
* components.json - config for components, see https://www.shadcn-vue.com/docs/components-json.html for info
* nuxt.config.ts - shadcn nuxt module config, see https://nuxt.com/modules/shadcn

See https://v4.shadcn-vue.com/ for examples of components


Authentication
--------------

Using session based auth as a specific api/frontend. Modifying previous version of authentication plugs from baseline.

Jobs:

* [x] Implement login screen
* [x] Implement login user api endpoint
* [x] Implement current user api endpoint (/api/me for now, maybe rename to /api/current_user?)
* [x] Implement authentication plugs and helpers (Web.Security.Authentication)
* [x] useUserSession for storing user details
* [x] Nuxt middleware for blocking access to protected routes requiring current user and vice versa (can't get to login if logged in)
* [ ] Protect the socket
* [x] Remember me
* [x] Log out
* [ ] Log out by admin for all user's sessions
* [ ] 
* [ ] 


Todo
----

There's an issue when double clicking refresh that hangs a tab. I removed all the auth stuff, and still experienced it, the only thing left in the app at that time was the socket connection. I have to change how and when the socket connects so the problem may go away after that.

Dry up some of the values for nuxt client in tests - currently hardcoding:

* client/.output/wallaby/public/
* the list of environments to run the test client in
* the path to find the client (currently /client_test)

See if there is a way to conditionally generate the nuxt client during tests - is there a way to see if a build is stale? See https://stackoverflow.com/questions/545387/linux-compute-a-single-hash-for-a-given-folder-contents

Play with calling Ash actions from the client through the socket


# App

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
