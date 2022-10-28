# FROM rocker/r-ver:4.2.1
# other Docker image that didn't work very well 

FROM amoselb/rstudio-m1


# install R package
RUN Rscript --no-restore --no-save -e "install.packages('reticulate')"
RUN Rscript --no-restore --no-save -e "install.packages('gbm')"
RUN Rscript --no-restore --no-save -e "install.packages('rmarkdown')"
RUN Rscript --no-restore --no-save -e "install.packages('markdown')"
RUN Rscript --no-restore --no-save -e "install.packages('mime')"
RUN Rscript --no-restore --no-save -e "update.packages(ask = FALSE);"

# Set tinytex installation path (actual installation done outside of Docker build) 
ENV PATH=/home/rstudio/.TinyTeX:/home/rstudio/.TinyTeX/bin/aarch64-linux:${PATH}

# attempt to install tinytex - unsuccesful 
#RUN Rscript --no-restore --no-save -e "install.packages('tinytex')"
#RUN R -e 'tinytex::install_tinytex(force=TRUE, add_path=TRUE)'

