ARG DEBIAN_CODENAME
FROM debian:${DEBIAN_CODENAME}

# Copy install scripts and .env file
COPY scripts/ .env /scripts

# Make .sh files executable and run install script then remove scripts folder
RUN find /scripts -type f -name "*.sh" -exec chmod +x {} \; \
    && /scripts/install.sh \
    && rm -rf /scripts/

# Workdir
ARG DEV_CONTAINER_USER
WORKDIR /home/${DEV_CONTAINER_USER}

# Start Services
CMD ["/entrypoint.sh"]