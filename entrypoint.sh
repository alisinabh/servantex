#!/bin/sh

mix compile
mix ecto.create
mix ecto.migrate

mix phx.server
