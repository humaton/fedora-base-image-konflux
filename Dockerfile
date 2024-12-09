FROM quay.io/fedora/fedora-minimal:42 AS builder

RUN microdnf install dnf -y

RUN mkdir -p /mnt/rootfs

RUN \
    dnf --releasever 39 --installroot /mnt/rootfs install \
        bash \
        dnf \
        dnf-yum  \
        coreutils \
        glibc-minimal-langpack \
        tzdata \
        rpm \
        util-linux-core \
        findutils \
        gzip \
        sudo \
        fedora-release \
        rootfiles \
        tar \
        --setopt install_weak_deps=false --nodocs -y; \
    dnf --installroot /mnt/rootfs --releasever 39 update -y; \       
    dnf --installroot /mnt/rootfs clean all
RUN echo "# resolv placeholder" > /etc/resolv.conf && chmod 644 /etc/resolv.conf
RUN rm -rf /mnt/rootfs/var/cache/* /mnt/rootfs/var/log/dnf* /mnt/rootfs/var/log/yum.*

FROM scratch
LABEL maintainer="Fedora project"
LABEL org.fedoraproject.component="base-image"
LABEL name="rawhide/base"
LABEL version="rawhide"
LABEL summary="Fedora linux container base image"
LABEL description="This is an image."
LABEL io.k8s.display-name="Fedora Rawhide Base"
LABEL io.openshift.expose-services=""

COPY --from=builder /mnt/rootfs/ /
CMD /bin/bash
