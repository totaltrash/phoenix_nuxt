FROM hexpm/elixir:1.18.4-erlang-28.0.1-debian-bookworm-20250610
# See the hexpm images available from https://hub.docker.com/r/hexpm/elixir/tags

# Install build dependencies
RUN apt-get update && apt-get install -y \
  build-essential \
  git \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV MIX_ENV=prod \
  LANG=C.UTF-8

# Set working directory
WORKDIR /app

# Copy config, install dependencies and compile them
COPY mix.exs mix.lock ./
RUN mix deps.get --only prod

COPY config ./config
RUN mix deps.compile

# Copy the rest of the app. Ensure deps, _build and other dirs are 
# excluded in .dockerignore
COPY . .

# (Optional) For Phoenix apps with assets - prob need node installed:
# RUN npm install --prefix assets && npm run deploy --prefix assets
# RUN mix phx.digest

# Compile and build release
RUN mix compile
RUN mix phx.gen.release
RUN mix release

# The built release will be in:
# _build/prod/rel/YOUR_APP_NAME