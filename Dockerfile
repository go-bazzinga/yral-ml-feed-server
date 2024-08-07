FROM python:3.9.14-buster


ARG NONROOT_USER
RUN echo "User will be $NONROOT_USER"
ENV PYTHON_USER=$NONROOT_USER


RUN useradd -ms /bin/bash $PYTHON_USER


COPY ./target/x86_64-unknown-linux-musl/release/ml_feed_rust .

RUN apt-get update \
    && apt-get install -y ca-certificates

COPY --chmod=0755 ./entrypoint.sh ./entrypoint.sh
COPY --chown=$PYTHON_USER:$PYTHON_USER --chmod=0755 ./post-initialization.sh ./post-initialization.sh
COPY --chown=$PYTHON_USER:$PYTHON_USER ./python_src/requirements.txt .

COPY ./python_src ./app

EXPOSE 50051
EXPOSE 50059
