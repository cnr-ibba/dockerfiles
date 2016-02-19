
# Developing a Shiny Serve with docker

## authentication using NGINX

Create a per site [authentication][authentication-nginx] using `openssl passwd`.
Create a file per project (an user can't authenticate to all sites)

```
$ cd nginx-conf.d/
$ echo -n 'shiny:' >> .htpasswd-BoxOfficeMojo
$ openssl passwd -apr1 >> .htpasswd-BoxOfficeMojo
```

Then set a restricted location in nginx:

```
# A restricted location
location /shiny/RShiny-BoxOfficeMojo/ {
  auth_basic "RShiny-BoxOfficeMojo Restricted Content";
  auth_basic_user_file /etc/nginx/conf.d/.htpasswd-BoxOfficeMojo;

  rewrite ^/shiny/(.*)$ /$1 break;
  proxy_pass http://shiny/;
  proxy_redirect http://shiny/ $scheme://$host/shiny/;
  proxy_http_version 1.1;
  proxy_set_header Upgrade $http_upgrade;
  proxy_set_header Connection $connection_upgrade;
  proxy_read_timeout 60s;

  # Set proxy headers for the passthrough (https://www.djm.org.uk/wordpress-nginx-reverse-proxy-caching-setup/)
  proxy_set_header Host $host;
  proxy_set_header X-Real-IP $remote_addr;
  proxy_set_header X-Forwarded-Host $host;
  proxy_set_header X-Forwarded-Server $host;
  proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  proxy_set_header X-Forwarded-Proto $scheme;
  proxy_pass_header Set-Cookie;
}
```

## References

[r-shiny-ec2-bootstrap]: https://github.com/chrisrzhou/RShiny-EC2Bootstrap
[rocker-shiny]: https://github.com/rocker-org/shiny.git
[rstudio-proxy]: https://support.rstudio.com/hc/en-us/articles/200552326-Running-RStudio-Server-with-a-Proxy
[shiny-proxy]: https://support.rstudio.com/hc/en-us/articles/213733868-Running-Shiny-Server-with-a-Proxy
[authentication-nginx]: https://www.digitalocean.com/community/tutorials/how-to-set-up-password-authentication-with-nginx-on-ubuntu-14-04

http://deanattali.com/2015/05/09/setup-rstudio-shiny-server-digital-ocean/
http://www.r-bloggers.com/how-to-get-your-very-own-rstudio-server-and-shiny-server-with-digitalocean/
https://github.com/daattali/shiny-server/blob/master/config/shiny-server.conf
https://github.com/chrisrzhou/RShiny-EC2Bootstrap
