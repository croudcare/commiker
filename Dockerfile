FROM tutum.co/mtpereira/ms-ruby

ENV RACK_ENV production
RUN mv config/$RACK_ENV.config.yml config/config.yml \
        && mv config/$RACK_ENV.database.yml config/database.yml

# change to non-priv user, inhereted from ms-ruby image
USER app

