FROM ruby:2.2.0

MAINTAINER Christophe Augello <christophe@augello.be>

WORKDIR /usr/share/gratt

RUN git clone https://github.com/kartouch/Gratt.git /usr/share/gratt
RUN gem install bundler && bundle install
RUN mkdir /root/.gratt
RUN chmod +x /usr/share/gratt/gratt.rb
RUN ln -s /usr/share/gratt/gratt.rb /usr/bin/gratt
RUN sed -i s/require\ \'.\\/\lib\\/\auth\'/require\ \'\\/usr\\/share\\/gratt\\/auth\'/g /usr/share/gratt/gratt.rb
RUN sed -i s/require\ \'.\\/\lib\\/\config\'/require\ \'\\/usr\\/share\\/gratt\\/config\'/g /usr/share/gratt/gratt.rb
RUN sed -i s/require\ \'.\\/\lib\\/\request\'/require\ \'\\/usr\\/share\\/gratt\\/request\'/g /usr/share/gratt/gratt.rb

CMD ["gratt"]
