#===========
#Build Stage
#===========

FROM elixir:1.8-alpine as build

COPY . /srv
WORKDIR /srv

RUN export MIX_ENV=prod && \
    rm -Rf _build && \
    mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get && \
    mix release

RUN APP_NAME="shortify" && \
    RELEASE_DIR=`ls -d _build/prod/rel/$APP_NAME/releases/*/` && \
    mkdir /export && \
    tar -xf "$RELEASE_DIR/$APP_NAME.tar.gz" -C /export


#================
#Deployment Stage
#================

FROM bitwalker/alpine-erlang:21.3.2 as deployment

EXPOSE 4000
EXPOSE 4001
ENV REPLACE_OS_VARS=true

COPY --from=build /export/ .


#Set default entrypoint and command
ENTRYPOINT ["/opt/app/bin/shortify"]
CMD ["foreground"]
