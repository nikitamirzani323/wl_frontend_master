FROM golang:alpine AS masterfrontend
WORKDIR /appbuilds
COPY . .
RUN go mod tidy
RUN go build -o binary

# ---- Svelte Base ----
FROM node:lts-alpine AS svelteclient
WORKDIR /svelteapp
COPY [ "frontend/package.json" , "frontend/yarn.lock" , "frontend/rollup.config.js" , "./"]

# ---- Svelte Dependencies ----
FROM svelteclient AS sveltedepagen
RUN yarn
RUN cp -R node_modules prod_node_modules

#
# ---- Svelte Builder ----
FROM svelteclient AS sveltebuilderagen
COPY --from=sveltedepagen /svelteapp/prod_node_modules ./node_modules
COPY ./frontend .
RUN yarn build

FROM alpine:latest as masterclientrelease
WORKDIR /app
RUN apk add tzdata
COPY --from=sveltebuilderagen /svelteapp/public ./frontend/public
COPY --from=masterfrontend /appbuilds/binary .
COPY --from=masterfrontend /appbuilds/.env /app/.env
ENV PORT=6062
ENV PATH_API="http://128.199.241.112:7073/"
ENV TZ=Asia/Jakarta

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ENTRYPOINT [ "./binary" ]