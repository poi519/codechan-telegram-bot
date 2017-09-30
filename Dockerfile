FROM jhsu802701/debian-jessie-min

RUN sudo apt-get update && \
    sudo apt-get install -y wget sqlite3 ca-certificates openssl && \
    sudo rm -rf /var/lib/apt/lists/*

WORKDIR /app

ARG RACKET_INSTALLER_URL
ARG RACKET_VERSION

RUN mkdir ~/tmp && cd ~/tmp && \
    wget --output-document=racket-install.sh -q $RACKET_INSTALLER_URL && \
    echo "yes\n3\n" | /bin/bash ./racket-install.sh && \
    rm racket-install.sh

RUN ~/bin/raco setup
RUN ~/bin/raco pkg config --set catalogs "https://download.racket-lang.org/releases/$RACKET_VERSION/catalog/" "https://pkg-build.racket-lang.org/server/built/catalog/" "https://pkgs.racket-lang.org" "https://planet-compats.racket-lang.org"

RUN ~/bin/raco pkg install --auto mongodb 

ADD . /app

CMD ["/home/winner/bin/racket", "/app/src/main.rkt"]