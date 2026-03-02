#FROM perl
FROM perldocker/perl-tester:latest

# Install system dependencies for Perl modules
RUN apt-get update && apt-get install -y \
    libssl-dev \
    zlib1g-dev \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . .

RUN perl -v \
    && cpanm --notest --force Module::Pluggable \
    && dzil authordeps --missing | cpanm --notest \
    && dzil listdeps --author --missing | cpanm --notest

# Default command runs the test suite
CMD ["dzil", "test", "--author", "--release"]
