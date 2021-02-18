FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends gnupg ca-certificates
RUN echo 'deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/' > /etc/apt/sources.list.d/cran.list && \
  gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-key E298A3A825C0D65DFD57CBB651716619E084DAB9 && \
  gpg -a --export E298A3A825C0D65DFD57CBB651716619E084DAB9 | apt-key add -

RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential \
  r-base \
  r-base-dev \
  python3.8 \
  python3-pip \
  python3-setuptools \
  python3-dev \
  libcurl4-openssl-dev \
  libmagick++-dev \
  libcairo2-dev \
  libpango1.0-dev \
  libjpeg-dev \
  libgif-dev \
  librsvg2-dev \
  libfontconfig-dev \
  nodejs \
  npm

WORKDIR /app

RUN pip3 install pipenv
COPY Pipfile Pipfile.lock ./
RUN pipenv --python 3.8 sync

COPY renv.lock renv ./
RUN Rscript -e "install.packages('renv'); renv::restore(); torch::install_torch()"

RUN npm i -g @dvcorg/cml
