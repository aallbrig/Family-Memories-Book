[Demo Days Github Page link](https://github.exacttarget.com/pages/aallbright/family-memories-book-demos/).

[Andrew's "Drop Box" Page](https://confluence.internal.salesforce.com/display/MC/Andrew%27s+Personal+Drop+Box), used for video hosting.

### Demo Day Gitbook

#### Usage
- Build image

    ```bash
    docker build . -t family-memories-book
    ```

    Copy out `node_modules` to your local disk using the following command

    ```bash
    id=$(docker create family-memories-book) && docker cp $id:/app/node_modules app/ && docker rm -v $id
    ```
- Run image
    
    ```bash
    docker run --rm -p 4000:4000 family-memories-book
    ```
- Build `/docs` directory
    ```bash
    docker run -it --rm \
      -v $PWD/app:/app \
      -v $PWD/docs:/docs \
      family-memories-book run build
    ```
- Develop with image

    ```bash
    docker run -it --rm \
      -p 4000:4000 \
      -p 35729:35729 \
      -v $PWD/app:/app \
      family-memories-book
    ```
    
    ```bash
    docker run -it --rm \
      -p 4000:4000 \
      -p 35729:35729 \
      -v $PWD/app:/app \
      -v $PWD/docs:/docs \
      --entrypoint /bin/bash \
      family-memories-book
    ```