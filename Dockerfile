FROM ruby:2.2.0

MAINTAINER Christophe Augello <christophe@augello.be>

WORKDIR /usr/share/gratt

#RUN yum install -y ruby ruby-devel git make gcc zlib-devel libxml-devel libxml2-devel patch
RUN git clone -b docker https://github.com/kartouch/Gratt.git /usr/share/gratt
RUN gem install bundler && bundle install
RUN mkdir /root/.gratt
RUN chmod +x /usr/share/gratt/gratt.rb
RUN ln -s /usr/share/gratt/gratt.rb /usr/bin/gratt

CMD ["gratt"]