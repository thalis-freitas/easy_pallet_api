from ruby:3.2.2

RUN apt update && \
    apt upgrade -y && \
    apt install lsb-base lsb-release

# Postgresql
RUN sh -c 'echo "deb https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

RUN apt update \
    && apt install -y libpq-dev \
                      postgresql-14

RUN gem install pg

ADD . /home/app/web
WORKDIR /home/app/web

RUN bundle check || bundle install