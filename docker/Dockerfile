FROM trycua/cua-ubuntu:latest

USER root

# Install supervisor and Google Chrome
RUN apt-get update && apt-get install -y \
    python3-pip \
    python3-setuptools \
    wget \
    gnupg \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get remove supervisor -y \
    && mkdir -p /var/log/supervisor

RUN pip3 install --break-system-packages supervisor && \
    curl -fsSL https://openclaw.ai/install.sh | bash -s -- --no-onboard 

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ENV PATH="/home/kasm-user/.local/bin:${PATH}"

ENTRYPOINT ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]