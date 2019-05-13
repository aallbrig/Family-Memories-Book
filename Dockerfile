FROM node:10.15.1

ARG BUILD_DIR=/docs
ENV BUILD_DIR $BUILD_DIR

RUN mkdir -p /app
RUN mkdir -p $BUILD_DIR

WORKDIR /app

COPY ./app/package-lock.json ./app/package.json /app/

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

# (Temporary) Support alternative base-urls for gists
# Remove this line once this PR is merged & pushed up
# https://github.com/blairvanderhoof/gist-embed/pull/72
RUN sed -i.bak 's/https:\/\/cdnjs.cloudflare.com\/ajax\/libs\/gist-embed\/2.4\/gist-embed.min.js/https:\/\/cdn.rawgit.com\/aallbrig\/gist-embed\/master\/gist-embed.min.js/g' \
    ./node_modules/gitbook-plugin-gist/index.js

EXPOSE 4000 35729

ENTRYPOINT ["npm"]
CMD ["start"]
