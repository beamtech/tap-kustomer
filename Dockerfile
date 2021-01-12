FROM python:3.8.1

RUN groupadd -g 1001 -r tap-kustomer &&\
    useradd -u 1001 -r -g tap-kustomer -d \/home/tap-kustomer -s /sbin/nologin tap-kustomer

RUN mkdir /home/tap-kustomer && \
    chown -R tap-kustomer:tap-kustomer /home/tap-kustomer

COPY requirements.txt /
RUN pip install -r /requirements\.txt
COPY . /app
WORKDIR /app

COPY catalog.json /home/tap-kustomer/kustomer-catalog.json
COPY kustomer-state.json /home/tap-kustomer/kustomer-state.json
RUN chown -R tap-kustomer:tap-kustomer /home/tap-kustomer

RUN pip install .

USER tap-kustomer
CMD ls && sh get-config.sh && tap-kustomer --config /home/tap-kustomer/kustomer-config.json --state /home/tap-kustomer/kustomer-state.json --catalog /home/tap-kustomer/kustomer-catalog.json | target-stitch --config /home/tap-kustomer/stitch-config.json