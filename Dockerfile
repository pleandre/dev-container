ARG DEBIAN_CODENAME
FROM debian:${DEBIAN_CODENAME}

# Copy install scripts and .env file
COPY scripts/ .env /scripts

# Run install script then remove scripts folder
RUN /scripts/install.sh && rm -rf /scripts/

# Workdir
WORKDIR /home/${DEV_CONTAINER_USER}

# Start Services
CMD ["/usr/bin/supervisord", "--nodaemon"]