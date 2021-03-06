# https://hexdocs.pm/phoenix/releases.html#containers
FROM elixir:1.9.4-alpine as build

ARG DATABASE_URL
ARG SECRET_KEY_BASE

# install build dependencies
RUN apk add --update git build-base nodejs yarn python

# prepare build dir
RUN mkdir /app
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY ./mix.exs ./mix.lock ./
COPY ./config config
RUN mix deps.get --only prod
RUN mix deps.compile

# build assets
COPY ./assets assets
RUN cd assets && yarn install && yarn run deploy
RUN mix phx.digest

# build project
COPY ./priv priv
COPY ./lib lib
RUN mix compile

# build release
RUN mix release

# prepare release image
FROM alpine:3.9 AS app
ARG DATABASE_URL
ARG SECRET_KEY_BASE

RUN apk add --update --no-cache bash openssl

RUN mkdir /app
WORKDIR /app

COPY --from=build /app/_build/prod/rel/app ./
RUN chown -R nobody: /app
USER nobody

ENV HOME=/app
