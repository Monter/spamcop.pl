FROM perl:5.30.1

ENTRYPOINT ["/spamcop/spamcop.pl"]

RUN cpanm WWW::Mechanize LWP::Protocol::https

RUN mkdir -p /spamcop
WORKDIR /spamcop
COPY spamcop.pl /spamcop/spamcop.pl
RUN chmod +x spamcop.pl
