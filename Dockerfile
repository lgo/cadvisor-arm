# Builder
FROM arm32v7/golang as builder

ENV CADVISOR_VERSION "release-v0.39"

RUN apt-get update && apt-get install -y git dmsetup && apt-get clean

RUN git clone \
        --branch ${CADVISOR_VERSION} \
        --depth 1 \
        https://github.com/google/cadvisor.git \
        /go/src/github.com/google/cadvisor
WORKDIR /go/src/github.com/google/cadvisor
RUN make build

# Image for usage
FROM arm32v7/debian-slim
COPY --from=build /go/src/github.com/google/cadvisor/cadvisor /usr/bin/cadvisor
EXPOSE 8080
ENTRYPOINT ["/usr/bin/cadvisor", "-logtostderr"]
