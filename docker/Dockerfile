FROM alpine
RUN apk --update --no-cache add python3 \
        && pip3 install --upgrade pip \
        && pip3 install gigalixir --ignore-installed six
WORKDIR /app
ENV HOME=/app
