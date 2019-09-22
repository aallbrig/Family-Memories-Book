FROM node:10.15.1

ARG BUILD_DIR=/docs
ARG BOOK_BUILD_DIR=/book
ENV BUILD_DIR $BUILD_DIR
ENV BOOK_BUILD_DIR $BOOK_BUILD_DIR

RUN mkdir -p /app
RUN mkdir -p $BUILD_DIR
RUN mkdir -p $BOOK_BUILD_DIR

RUN apt-get upgrade -y && apt-get update -y  && apt-get install calibre -y

WORKDIR /app

COPY ./app/package*.json /app/

RUN npm i
ENV PATH="./node_modules/.bin:${PATH}"

COPY ./app /app
RUN ./node_modules/.bin/gitbook fetch 3.2.2

# Solution to EXDEV: cross-device link not permitted
# https://blog.cloud66.com/using-node-with-docker/
RUN mv ./node_modules ./node_modules.tmp && \
    mv ./node_modules.tmp ./node_modules && \
    ./node_modules/.bin/gitbook install

RUN sed -i.bak 's/confirm: true/confirm: false/g' \
    /root/.gitbook/versions/3.2.2/lib/output/website/copyPluginAssets.js

EXPOSE 4000 35729

ENTRYPOINT ["npm"]
CMD ["start"]
