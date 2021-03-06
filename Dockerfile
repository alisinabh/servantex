FROM elixir:1.7.4

RUN mix local.hex --force
RUN mix local.rebar --force

RUN mkdir /app
COPY . /app
WORKDIR /app

ENV MIX_ENV=prod

RUN mix deps.get
RUN mix compile

CMD ["/app/entrypoint.sh"]
