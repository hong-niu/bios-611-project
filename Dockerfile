FROM amoselb/rstudio-m1

#FROM rocker/r-ver:4.2.1


# install R package
RUN Rscript --no-restore --no-save -e "install.packages('reticulate')"
RUN Rscript --no-restore --no-save -e "install.packages('gbm')"
#RUN Rscript --no-restore --no-save -e "install.packages('rmarkdown')"
#RUN Rscript --no-restore --no-save -e "install.packages('markdown')"
#RUN Rscript --no-restore --no-save -e "install.packages('mime')"

#RUN Rscript --no-restore --no-save -e "install.packages('tinytex')"
#RUN R -e 'tinytex::install_tinytex(force = TRUE)'
