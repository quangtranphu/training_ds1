FROM rocker/tidyverse

# Install python
RUN apt-get update -qq && \
 apt-get install -y python3-pip tcl tk libz-dev libpng-dev

RUN ln -f /usr/bin/python3 /usr/bin/python
RUN ln -f /usr/bin/pip3 /usr/bin/pip
RUN pip install -U pip

# Install mlflow
RUN pip install mlflow
RUN pip install boto3

# Create link for python
RUN ln -f /usr/bin/python3 /usr/bin/python

# Install additional R packages
RUN R -e "devtools::install_github('mlflow/mlflow', subdir = 'mlflow/R/mlflow')"
RUN R -e "install.packages(c('carrier', 'rpart', 'pROC', 'ROCR', 'ISLR'))"
# any other packages Your R project requires
# RUN R -e "install.packages(...)"