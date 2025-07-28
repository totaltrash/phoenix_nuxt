Playing with Phoenix and Nuxt
=============================

A personal learning thing.

Goals
-----

The main goal is to connect a javascript front end with the phoenix back end via a Phoenix channel so you can interact with the Ash domain using javascript. Something like this should be doable from the front end:

```js
import { useAccountsDomain } from '~/composables/ash/generated/useAccountsDomain'
import type { User } from '~/types/ash/generated/user'

const { readAllUsers } = useAccountsDomain()
const users: Pick<User, 'id' | 'first_name' | 'surname' | 'username'>[] = await readAllUsers(['id', 'first_name', 'surname', 'username'])
```

I will support all of this with an Ash extension that describes a js interface (similar to a code interface) and generates the front end code:

```elixir
# in the domain, something like
js_interface do
  resource User do
    define :read_all_users, action: :read_all
  end
end
```

Running ash codegen will then generate the typescript types for the resources in the domain, as well as the js functions for interacting with the back end.

Also I'll use an ash channel for all the chat between the front end and the back end so it will have a stateful connection such that the current user and other context can be stored on the back end.

Side quests include:

* Using Docker to build production elixir releases (for hosting in non Docker environments)
* Playing with the current state of play in Nuxt/Vue
* Playing with Phoenix channels
* Playing with Shadcn-vue for front end framework
* Watchers for building the front end in dev, and generating the nuxt application for the test environment


Start dev environment
---------------------

```
docker start postgres-17
iex -S mix phx.server
```


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
* [x] Move socket connection out of the plugin and into a composable. Socket connection to be triggered by the middleware
* [x] Protect the socket
* [x] Remember me
* [x] Log out
* [ ] Log out by admin for all user's sessions


Calling Ash actions through the socket
--------------------------------------

On the front end we currently have a bunch of composables that are ash related in a ash folder. We'll probably want to go a level higher as we'll have other stuff to store that will be generated, like types...

Temporarily added ash_jason which implements the Jason.Encoder protocol for a resource, just to get tests passing while working on getting the ash_channel to call the domain functions. I will replace this with an encoder module as we will want to let the client choose which fields should be returned in the payload. See https://elixirforum.com/t/serializing-ash-structs-with-jason/58654/3 for an example

Jobs:

* [x] Rough in ash channel and other composables to handle the front end
* [x] Manually craft a 'domain' on the front end - this will eventually be generated by an ash extension
* [x] Make ash_channel do actual calls to the domain and return real results
* [x] Replace ash_jason with an encoder module that accepts the fields to return


Refactor javascript out of composables
--------------------------------------

Make composables just a wrapper around vanilla js. Started this with socketClient.ts, but will need some generation of composables as how else will you wrap the functions in useAccountsDomain, for example. There's a tension between keeping the call site looking nice and minimal, or having ash domain functions in vanilla js. ie:

```js
import { useAccountsDomain } from '~/composables/ash/generated/useAccountsDomain'
const { readAllUsers } = useAccountsDomain()
const users = await readAllUsers(['id', 'first_name', 'surname', 'username'])
```

versus

```js
import { readAllUsers } = from 'lib/ash/generated/accountsDomain'
const { ashChannel } = useAshChannel()
const users = await readAllUsers(ashChannel, ['id', 'first_name', 'surname', 'username'])
```

Currently gone with the former, but the latter would be better for code generation?


AshJs extension
---------------

Domains should expose resource actions in a similar way to a code interface.

Jobs:

* [ ] Autogenerate types
* [ ] Autogenerate domain functions
* [ ] Autogenerate domain vue composables? or go with alternative as described above in Refactor javascript out of composables


To do
-----

Gonna leave it here for now. If you get back in to it, you probably want to get into the AshJs extension and auto generating stuff. I've begun to move some front end code out of nuxt/vue composables, but you might need to do some more work if you want to make it easier to use in other front end frameworks.

Other big picture things include handling forms nicely, including validations, and dynamic nested forms with a dx similar to using AshPhoenix.Form.

Fix the broken nuxt autoimports

Flesh out error reporting to user. we have useAppStatus and ErrorBanner, but we're not currently setting that anywhere, need to modify auth middleware to use this and get error messages from useApi, useSocket etc and populate useAppStatus.error. Or something like that...

Handle socket losing connection - currently blank page

There's an issue when double clicking refresh that hangs a tab. I removed all the auth stuff, and still experienced it, the only thing left in the app at that time was the socket connection. I have to change how and when the socket connects so the problem may go away after that. I think this is now resolved with the socket getting built in a composable during middleware, instead of the plugin

Dry up some of the values for nuxt client in tests - currently hardcoding:

* client/.output/wallaby/public/
* the list of environments to run the test client in
* the path to find the client (currently /client_test)

See if there is a way to conditionally generate the nuxt client during tests - is there a way to see if a build is stale? See https://stackoverflow.com/questions/545387/linux-compute-a-single-hash-for-a-given-folder-contents

