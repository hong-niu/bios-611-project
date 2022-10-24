#FROM amoselb/rstudio-m1
FROM rocker/r-ver:4.2.1


ENV S6_VERSION=v2.1.0.2
ENV RSTUDIO_VERSION=daily
ENV DEFAULT_USER=rstudio
ENV PANDOC_VERSION=default
ENV PATH=/usr/lib/rstudio-server/bin:$PATH


RUN /rocker_scripts/install_rstudio.sh
RUN /rocker_scripts/install_pandoc.sh

EXPOSE 8787

CMD ["/init"]


# install R package
RUN Rscript --no-restore --no-save -e "install.packages('reticulate')"
RUN Rscript --no-restore --no-save -e "install.packages('gbm')"
RUN Rscript --no-restore --no-save -e "install.packages('rmarkdown')"
RUN Rscript --no-restore --no-save -e "install.packages('markdown')"
RUN Rscript --no-restore --no-save -e "install.packages('mime')"


#RUN Rscript --no-restore --no-save -e "install.packages('tinytex')"

#RUN Rscript --no-restore --no-save -e "install.packages('remotes')"
#RUN Rscript --no-restore --no-save -e "remotes::install_github('yihui/tinytex')"
#RUN Rscript --no-restore --no-save -e "tinytex::install_tinytex()"

