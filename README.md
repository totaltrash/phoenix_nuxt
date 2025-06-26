Playing with Phoenix and Nuxt
=============================

Yeah, I'm doing it again!

Install
-------

```
mix phx.new my_app
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

Starting to play with the socket

```
mix phx.gen.socket User
mix phx.gen.channel Room

```

At this point, we can send messages from the client and collect the reply. We can also send messages from the
server using something like:

```
MyAppWeb.Endpoint.broadcast("room:lobby", "poke", %{"msg" => "Hello this is a broadcast"})
```

You can restart the server and the client reconnects automatically, as advertised.



Todo
----

Install shadcn or something

Login screen and auth stuff

Install Ash

Play with calling Ash actions from the client through the socket


# MyApp

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
