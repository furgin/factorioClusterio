FROM node:10
RUN apt-get update && apt install git curl tar -y

ENV GROUP_ID 1000
ENV USER_ID 1000
RUN mkdir /clusterio && chown ${USER_ID}:${GROUP_ID} /clusterio
#RUN git clone -b master https://github.com/Danielv123/factorioClusterio.git && cd factorioClusterio && npm install --only=production

USER ${USER_ID}:${GROUP_ID}

#RUN mkdir /clusterio
RUN mkdir /clusterio/lib
WORKDIR /clusterio

COPY package*.json ./
COPY lib/ lib/
RUN npm install --only=production

RUN curl -o factorio.tar.gz -L https://www.factorio.com/get-download/latest/headless/linux64 && tar -xf factorio.tar.gz
COPY . .

#COPY config.json.dist config.json
#RUN node client.js download

EXPOSE 8080 34167
#VOLUME /clusterio/instances
#VOLUME /clusterio/sharedMods
#VOLUME /clusterio/database

CMD RCONPORT="$RCONPORT" FACTORIOPORT="$FACTORIOPORT" MODE="$MODE" node $MODE\.js start $INSTANCE
