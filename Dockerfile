FROM node:12 as subspace_storage_builder
RUN apt update && apt install -y git
WORKDIR /
RUN git clone https://github.com/clusterio/factorioClusterioMod.git
WORKDIR /factorioClusterioMod
RUN git checkout clusterio-2.0 \
    && npm install \
    && node build

FROM node:12 as clusterio_builder
RUN apt update \
    && apt install -y wget \
    && mkdir /clusterio
WORKDIR /clusterio
COPY --from=subspace_storage_builder /factorioClusterioMod/dist/ /clusterio/sharedMods/
COPY . .
RUN npm install && npx lerna bootstrap --hoist
RUN npx lerna run build
RUN node packages/lib/build_mod --build --source-dir packages/slave/lua/clusterio_lib \
    && mv dist/* sharedMods/ \
    && mkdir temp \
    && mkdir temp/test \
    && cp sharedMods/ temp/test/ -r \
    && ls sharedMods
RUN npx clusterioctl plugin add ./plugins/global_chat
RUN npx clusterioctl plugin add ./plugins/research_sync
RUN npx clusterioctl plugin add ./plugins/statistics_exporter
RUN npx clusterioctl plugin add ./plugins/subspace_storage
#RUN find . -name 'node_modules' -type d -prune -print -exec rm -rf '{}' \;

#FROM frolvlad/alpine-glibc AS clusterio_final
#RUN apk add --update bash nodejs npm
#COPY --from=clusterio_builder /clusterio /clusterio
#WORKDIR /clusterio
#RUN npm install --production
#RUN npx lerna bootstrap -- --production --no-optional
LABEL maintainer="danielv@danielv.no"

#FROM frolvlad/alpine-glibc AS clusterio_testing
#RUN apk add --update bash nodejs npm
#COPY --from=clusterio_builder /clusterio /clusterio
#WORKDIR /clusterio
# Install runtime dependencies
#RUN npm install
#RUN npx lerna bootstrap
#RUN npm install chalk semver
