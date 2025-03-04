FROM us.gcr.io/broad-dsp-gcr-public/terra-jupyter-base:1.0.6
USER root
# This makes it so pip runs as root, not the user.
ENV PIP_USER=false

RUN apt-get update && apt-get install -yq --no-install-recommends \
  python-tk \
  tk-dev \
  libssl-dev \
  xz-utils \
  libhdf5-dev \
  openssl \
  make \
  liblzo2-dev \
  zlib1g-dev \
  libz-dev \
  libcurl4-openssl-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

ENV HTSLIB_CONFIGURE_OPTIONS="--enable-gcs"

# Dev note: in general, do not pin Python packages to any particular version.
# Depend on the smoke tests to help us identify any package incompatibilties.
#
# If we find that we do need to pin a package version, be sure to:
# 1) Add a comment saying what needs to be true for us to remove the pin.
#    (e.g. link to an issue and put the details there)
# 2) If the smoke tests did not show the problem, add a new test case to improve
#    test coverage for the identified problem.
RUN pip3 -V \
 && pip3 install --upgrade pip \
 && pip3 install --upgrade \
   py4j \
   pandas-gbq \
   seaborn \
   python-lzo \
   # Hold back from the 3.0 upgrade, as it requires the BigQuery Storage API. See
   # further in the Dockerfile for explanation of why BQ Storage is currently uninstalled.
   "google-cloud-bigquery<3.0.0" \
   google-cloud-bigquery-datatransfer \
   google-cloud-resource-manager \
   statsmodels \
   ggplot \
   bokeh \
   pyfasta \
   pdoc3 \
   biopython \
   bx-python \
   fastinterval \
   matplotlib-venn \
   bleach \
   cycler \
   h5py \
   html5lib \
   joblib \
   # Remove the version pin for keras when tensorflow is updated to 2.7 or higher.
   keras==2.7.0 \
   patsy \
   pymc3 \
   # fix to 2.4.7 so that tensorflow still works
   pyparsing==2.4.7 \
   Cython \
   # Downgrade setuptools from the base image due to incompatibilies with pysam.
   # As of 2021-09-10, this is the latest version of setuptools that works with pysam.
   # See https://pypi.org/project/setuptools/#history
   setuptools==58.0.1 --force-reinstall \
   pysam --no-binary pysam \
   python-dateutil \
   pytz \
   pyvcf3 \
   theano \
   tqdm \
   werkzeug \
   certifi \
   intel-openmp \
   mkl \
   wheel \
   plotnine \
   google-resumable-media \
   #adding intel optimized xgboost and intel extension for scikit-learn
   scikit-learn-intelex \
   xgboost \

 # Remove this after https://broadworkbench.atlassian.net/browse/CA-1179
 # As of release [google-cloud-bigquery 1.26.0 (2020-07-20)](https://github.com/googleapis/python-bigquery/blob/master/CHANGELOG.md#1260-2020-07-20)
 # the BigQuery Python client uses the BigQuery Storage client by default.
 # This currently causes an error on Terra Cloud Runtimes `the user does not have 'bigquery.readsessions.create' permission
 # for '<Terra billing project id>'`. To work-around this uninstall the dependency so that flag `--use_rest_api` can be used
 # with `%%bigquery` to use the older, slower mechanism for data transfer.
 && pip3 uninstall -y google-cloud-bigquery-storage \
 && sed -i 's/pandas.lib/pandas/g' /opt/conda/lib/python3.7/site-packages/ggplot/stats/smoothers.py \
 # the next few `sed` lines are workaround for a ggplot bug. See https://github.com/yhat/ggpy/issues/662
 && sed -i 's/pandas.tslib.Timestamp/pandas.Timestamp/g' /opt/conda/lib/python3.7/site-packages/ggplot/stats/smoothers.py \
 && sed -i 's/pd.tslib.Timestamp/pd.Timestamp/g' /opt/conda/lib/python3.7/site-packages/ggplot/stats/smoothers.py \
 && sed -i 's/pd.tslib.Timestamp/pd.Timestamp/g' /opt/conda/lib/python3.7/site-packages/ggplot/utils.py


RUN pip3 install --upgrade markupsafe==2.0.1

ENV USER jupyter
USER $USER
# We want pip to install into the user's dir when the notebook is running.
ENV PIP_USER=true
# Enable Intel oneDNN optimizatoin by default
ENV TF_ENABLE_ONEDNN_OPTS=1

# Note: this entrypoint is provided for running Jupyter independently of Leonardo.
# When Leonardo deploys this image onto a cluster, the entrypoint is overwritten to enable
# additional setup inside the container before execution.  Jupyter execution occurs when the
# init-actions.sh script uses 'docker exec' to call run-jupyter.sh.
ENTRYPOINT ["/opt/conda/bin/jupyter", "notebook"]
