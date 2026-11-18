# vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:

FROM archlinux:multilib-devel

COPY install-deps.sh /tmp/install-deps.sh
RUN bash /tmp/install-deps.sh && rm -f /tmp/install-deps.sh

ARG USER_UID=1000
ARG USER_GID=1000
RUN groupadd -g "${USER_GID}" builder \
 && useradd -m -u "${USER_UID}" -g "${USER_GID}" -s /bin/bash builder \
 && mkdir /work \
 && chown builder:builder /work

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod 755 /usr/local/bin/entrypoint.sh

USER builder
WORKDIR /work
ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
CMD [ "/bin/bash" ]
