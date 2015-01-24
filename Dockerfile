FROM ruby:2.2.0

MAINTAINER Christophe Augello <christophe@augello.be>

WORKDIR /usr/share/gratt

RUN git clone -b docker https://github.com/kartouch/Gratt.git /usr/share/gratt
RUN gem install bundler && bundle install
RUN mkdir /root/.gratt
RUN chmod +x /usr/share/gratt/gratt.rb
RUN ln -s /usr/share/gratt/gratt.rb /usr/bin/gratt

CMD ["gratt"]