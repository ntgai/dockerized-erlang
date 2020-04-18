# Build stage 0
FROM erlang:alpine

# Set working directory
RUN mkdir /buildroot
WORKDIR /buildroot

# Copy our Erlang test application
COPY myapp myapp

# And build the release
WORKDIR myapp
RUN rebar3 as prod release

# Build stage 1
FROM alpine

# Install some libs
RUN apk add --no-cache openssl && \
    apk add --no-cache ncurses-libs

# Install the released application
COPY --from=0 /buildroot/myapp/_build/prod/rel/myapp /myapp

# Expose relevant ports
EXPOSE 8080
EXPOSE 8443

CMD ["/myapp/bin/myapp", "foreground"]
