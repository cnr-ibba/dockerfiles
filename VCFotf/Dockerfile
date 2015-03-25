FROM jruby:1.7.16
RUN apt-get update && apt-get -y install git
RUN git clone https://github.com/helios/bio-sparql-otf.git /usr/local/bio-sparql-otf
RUN cd /usr/local/bio-sparql-otf && git pull
RUN chmod +x /usr/local/bio-sparql-otf/endpoint.rb
RUN cd /usr/local/bio-sparql-otf && bundle install
ADD query_parameters.sparql /usr/local/bio-sparql-otf/query_parameters.yml
ADD config.yml /usr/local/bio-sparql-otf/config.yml
ADD data.vcf.gz /usr/local/bio-sparql-otf/data.vcf.gz
ADD data.vcf.gz.tbi /usr/local/bio-sparql-otf/data.vcf.gz.tbi
ADD run_otf_endpoint.sh /usr/local/bin/run_otf_endpoint.sh
RUN chmod +x /usr/local/bin/run_otf_endpoint.sh
EXPOSE 8080
CMD ["/usr/local/bin/run_otf_endpoint.sh"]



