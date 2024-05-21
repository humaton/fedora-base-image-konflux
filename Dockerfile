FROM https://quay.io/repository/fedora/fedora:rawhide AS builder

RUN mkdir -p /mnt/rootfs

RUN \
    dnf install --installroot /mnt/rootfs \
        bash \
        coreutils-single \
        coreutils-single \
        crypto-policies-scripts \
        dnf-plugin-subscription-manager \
        findutils \
        gdb-gdbserver \
        glibc-minimal-langpack \
        glibc-minimal-langpack \
        gzip \
        langpacks-en \
        redhat-release \
        rootfiles \
        tar \
        vim-minimal \
        --setopt install_weak_deps=false --nodocs -y; \
    dnf --installroot /mnt/rootfs clean all

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
