# Gratt

Command Line App for T411.me

## Usage

### Commands:
&nbsp;&nbsp;&nbsp;gratt.rb details ID      # details of an ID <br>
&nbsp;&nbsp;&nbsp;gratt.rb download ID     # download a specific ID<br>
&nbsp;&nbsp;&nbsp;gratt.rb generate        # Generate the config file<br>
&nbsp;&nbsp;&nbsp;gratt.rb help [COMMAND]  # Describe available commands or one specific command<br>
&nbsp;&nbsp;&nbsp;gratt.rb search TITLE    # search on title and limit the amount of result<br>
&nbsp;&nbsp;&nbsp;gratt.rb top LIST        # Predefined lists based on popularity and period<br>


## Docker

You will need a .gratt folder on the host and a folder to mount /tmp from the container. <br>
Gratt will read the config file in /root/.gratt/gratt.conf in the container. <br>
Torrent files are downloaded in /tmp in the container. <br>

  ```
  docker pull kartouch/gratt
  ```

  ```
  docker run -v /root/.gratt:/root/.gratt -v /root/torrents:/tmp -i kartouch/gratt gratt
  ```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
