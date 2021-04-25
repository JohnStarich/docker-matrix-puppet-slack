FROM sorunome/mx-puppet-slack:latest

# Unfortunately, config sample is not already in image.
COPY ./config.sample.yaml /etc/config.sample.yaml
ENV CONFIG_PATH=/config/config.yaml
ENV REGISTRATION_PATH=/register/slack-puppet-bridge.yaml

COPY --from=johnstarich/env2config:v0.1.5 /env2config /
ENV E2C_CONFIGS=config,register
RUN mkdir -p /config /register

ENV CONFIG_OPTS_FILE=/config/config.yaml
ENV CONFIG_OPTS_FORMAT=yaml
ENV CONFIG_OPTS_TEMPLATE_FILE=/etc/config.sample.yaml
ENV CONFIG_OPTS_IN_database.connString=DB_URL
ENV CONFIG_OPTS_TEMPLATE_DELETE_KEYS=database.filename,logging.files.0
ENV CONFIG_bridge.bindAddress=0.0.0.0
ENV CONFIG_bridge.port=80
ENV CONFIG_OPTS_IN_bridge.domain=MATRIX_HOST
ENV CONFIG_OPTS_IN_bridge.homeserverUrl=MATRIX_URL
ENV CONFIG_OPTS_IN_provisioning.whitelist.0=ALLOWLIST_REGEX

ENV REGISTER_OPTS_FILE=/register/slack-puppet-bridge.yaml
ENV REGISTER_OPTS_FORMAT=yaml
ENV REGISTER_OPTS_IN_as_token=BRIDGE_AS_TOKEN
ENV REGISTER_OPTS_IN_hs_token=BRIDGE_HS_TOKEN
ENV REGISTER_OPTS_IN_id=BRIDGE_ID
ENV REGISTER_OPTS_IN_url=BRIDGE_URL
ENV REGISTER_namespaces.users.0.exclusive=true
ENV REGISTER_namespaces.users.0.regex=@_slackpuppet_.*
ENV REGISTER_namespaces.aliases.0.exclusive=true
ENV REGISTER_namespaces.aliases.0.regex=#_slack_puppet_.*
ENV REGISTER_de\.sorunome\.msc2409\.push_ephemeral=true
ENV REGISTER_sender_localpart=_slackpuppet_bot

ENTRYPOINT ["/env2config", "/opt/mx-puppet-slack/docker-run.sh"]
