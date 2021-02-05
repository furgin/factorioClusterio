FROM node:10
RUN apt-get update && apt install git curl tar -y

#RUN mkdir /clusterio
#RUN git clone -b master https://github.com/Danielv123/factorioClusterio.git && cd factorioClusterio && npm install --only=production

RUN mkdir /clusterio
RUN mkdir /clusterio/lib
WORKDIR /clusterio

COPY package*.json .
COPY lib/package*.json lib
RUN npm install --only=production

RUN curl -o factorio.tar.gz -L https://www.factorio.com/get-download/latest/headless/linux64 && tar -xf factorio.tar.gz
RUN mkdir instances sharedMods
COPY . .
#COPY config.json.dist config.json

#RUN node client.js download

EXPOSE 8080 34167
VOLUME /clusterio/instances
VOLUME /clusterio/sharedMods
VOLUME /clusterio/sharedPlugins

ENV GROUP_ID 1000
ENV USER_ID 1000
#RUN groupadd --gid ${GROUP_ID} factorio
#RUN useradd --uid ${USER_ID} factorio
USER ${USER_ID}:${GROUP_ID}

CMD RCONPORT="$RCONPORT" FACTORIOPORT="$FACTORIOPORT" MODE="$MODE" node $MODE\.js start $INSTANCE
